from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest


@unittest.skipUnless(shutil.which('zsh'), 'Zsh is required for startup tests')
class StartupTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.home = Path(self.temp.name)
        source = Path(__file__).resolve().parents[3]
        for name in ('.zshenv', '.config/zsh/.zshenv', '.config/zsh/.zprofile',
                     '.config/zsh/.zshrc', '.config/shell/env',
                     '.config/shell/profile', '.config/shell/aliasrc'):
            target = self.home / name
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(source / name, target)
        # Exercise interactive startup without installing plugins or using a network.
        plugin = self.home / '.local/share/zinit/zinit.git/zinit.zsh'
        plugin.parent.mkdir(parents=True)
        plugin.write_text('zinit() { :; }\n')
        self.env = dict(HOME=str(self.home), PATH='/usr/bin:/bin', TERM='xterm', USER='test')

    def shell(self, command, *options):
        return subprocess.run(['zsh', *options, '-c', command], env=self.env,
                              capture_output=True, text=True, check=True).stdout.strip()

    def test_environment_in_nonlogin_login_and_interactive_shells(self):
        for options in ((), ('-l',), ('-i',)):
            with self.subTest(options=options):
                actual = self.shell('print -r -- "$ZDOTDIR|$XDG_STATE_HOME|$ANSIBLE_HOME|$LESSHISTFILE"', *options)
                expected = '|'.join(str(self.home / name) for name in
                                    ('.config/zsh', '.local/state', '.local/share/ansible', '.local/state/less/history'))
                self.assertEqual(actual, expected)

    def test_completion_cache_stays_outside_configuration(self):
        self.shell(':', '-i')
        self.assertTrue((self.home / '.cache/zsh/zcompdump').exists())
        self.assertFalse((self.home / '.zcompdump').exists())
        self.assertFalse((self.home / '.config/zsh/.zcompdump').exists())

    def test_neovim_config_is_not_overridden_by_viminit(self):
        self.env['VIMINIT'] = 'source /old/vimrc'
        self.assertEqual(self.shell('print -r -- "${VIMINIT-unset}"'), 'unset')

    def test_existing_x_authentication_is_preserved(self):
        self.env['XAUTHORITY'] = '/existing/session/auth'
        self.assertEqual(self.shell('print -r -- "$XAUTHORITY"'), '/existing/session/auth')

    def test_authentication_uses_runtime_or_state_directory(self):
        self.assertEqual(self.shell('print -r -- "$XAUTHORITY"'), str(self.home / '.local/state/x11/Xauthority'))
        runtime = self.home / 'runtime'
        runtime.mkdir(mode=0o700)
        self.env['XDG_RUNTIME_DIR'] = str(runtime)
        self.assertEqual(self.shell('print -r -- "$XAUTHORITY"'), str(runtime / 'Xauthority'))

    def test_subshell_with_inherited_zdotdir_reads_relocated_environment(self):
        self.env['ZDOTDIR'] = str(self.home / '.config/zsh')
        self.assertEqual(self.shell('print -r -- "$ANSIBLE_LOCAL_TEMP"'), str(self.home / '.cache/ansible/tmp'))
