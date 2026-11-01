return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- This config uses the legacy master API.
    branch = "master",
    lazy = false,
    build = ":TSUpdate",
    config = function ()
      -- Avoid tarball layout assumptions; the Lua grammar uses main, not master.
      require("nvim-treesitter.install").prefer_git = true
      require("nvim-treesitter.parsers").get_parser_configs().lua.install_info.branch = "main"
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html", "python", "go", "yaml", "markdown", "bash" },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
}
