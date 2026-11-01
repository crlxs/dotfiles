# Debian desktop dotfiles

Shell, Neovim, tmux and X session configuration for the Debian desktop installed
by [crlxs/rice](https://github.com/crlxs/rice). The desktop uses the
[dwm](https://github.com/crlxs/dwm), [st](https://github.com/crlxs/st), and
[dmenu](https://github.com/crlxs/dmenu) forks.

## Install on a new machine

On Debian 12 or newer (x86_64 or ARM64), run as your desktop user:

```sh
sudo apt update
sudo apt install -y ansible-core git ca-certificates
mkdir -p ~/.local/src ~/.local/share
git clone https://github.com/crlxs/rice.git ~/.local/src/rice
cd ~/.local/src/rice
ansible-playbook -i localhost, setup.yaml --ask-become-pass
```

Skip the clone if `~/.local/src/rice` already exists. Ansible requests sudo when needed;
run the playbook without sudo. It installs dependencies, fonts, Neovim, the
suckless forks, and checks out these dotfiles. Initial conflicting files are
backed up under `~/.local/state/rice/backups/`; tracked local edits are preserved.

Use `--tags common` for shell/editor/dotfiles only, `--tags suckless` for the
desktop only, or `--tags fonts` for fonts only. Restoring the optional vaulted
SSH identity requires the separate `gitssh` tag and vault password; see the
[rice README](https://github.com/crlxs/rice#readme).

## Start the desktop

Log out and back in, then run `startx` from a local text console. The shell
bootstrap sets `XINITRC` to `~/.config/x11/xinitrc`. Without that environment, use:

```sh
startx "$HOME/.config/x11/xinitrc"
```

Picom uses XRender for transparency, including on guests without OpenGL/3D
acceleration. Its log is `~/.cache/picom.log`. The default wallpaper is the
jaguar image installed at `~/.local/share/wallpaper`.

Super + Shift + Enter opens st; Super + p opens dmenu; Super + Shift + q exits
dwm. Save your work before exiting. Forks define the remaining bindings and
appearance defaults in their tracked `config.def.h` files.

## Manage this bare repository

Git metadata lives in `~/.local/share/dotfiles`; your home directory is its work tree.
Always pass both paths when managing dotfiles. Add specific files rather than
adding the whole home directory:

```sh
git --git-dir="$HOME/.local/share/dotfiles" --work-tree="$HOME" status
git --git-dir="$HOME/.local/share/dotfiles" --work-tree="$HOME" diff
git --git-dir="$HOME/.local/share/dotfiles" --work-tree="$HOME" add .config/x11/xinitrc
git --git-dir="$HOME/.local/share/dotfiles" --work-tree="$HOME" commit -m "Update X startup"
git --git-dir="$HOME/.local/share/dotfiles" --work-tree="$HOME" push origin HEAD
```

The root `~/.zshenv` loads the environment from `.config/zsh/.zshenv`; login
settings live in `.config/zsh/.zprofile`. Global ignore rules live in
`~/.config/git/ignore`. Repository documentation lives here, under
`~/.config/dotfiles/README.md`, rather than creating `~/README.md`.

Zsh caches and local backups are ignored. Neovim's `lazy-lock.json` is tracked
to preserve plugin revisions. Font packages and Nerd Font downloads are managed
by rice; the fontconfig fallback file is also tracked here.

The installer maintains X startup templates and the bundled wallpaper in
`rice/files/`. Keep those copies aligned with changes to the corresponding
dotfiles, then commit and push both repositories. Change and push each fork's
`config.def.h` to publish new terminal, window manager or launcher defaults.

The installer preserves existing clones. Review local changes before fetching
and selecting updates; rerunning the playbook does not pull newer revisions.

## Home directory layout

Configuration lives in `~/.config`, programs and repository data in `~/.local`,
and disposable caches in `~/.cache`. Zsh, less and Vim history live under
`~/.local/state`. Zsh completion dumps live under `~/.cache/zsh`. Ansible has
its data under `~/.local/share/ansible` and temporary files under `~/.cache/ansible`.

The rice migration preserves displaced legacy files under
`~/.local/state/rice/backups/<timestamp>/`. It moves the old bare `~/.dotfiles`
repository without discarding uncommitted changes. Relocate a legacy `~/rice`
checkout separately after Ansible exits, as described in the rice README. If both
old and new repository destinations exist, migration stops for review. A clean,
redundant `~/dotfiles` checkout is archived only when its current commit is
already in the active dotfiles history.

Close old shell sessions and log back in after migration. Existing sessions can
keep writing to their former history paths. Bash fallback files, SSH credentials,
unmanaged application directories, and existing X authentication files are kept.
New X sessions use the runtime directory for authentication when available, with
a private state directory as fallback.

Validate shell startup without downloading plugins:

```sh
python3 -m unittest discover -s "$HOME/.config/dotfiles/tests" -v
```
