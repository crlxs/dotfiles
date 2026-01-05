return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",
  lazy = false, -- neo-tree will lazily load itself
  config = function()
    require("bufferline").setup({})
    vim.keymap.set('n', '<leader><Tab>', ":bnext<CR>", { desc = "Next buffer"})
    vim.keymap.set('n', '<leader><S-Tab>', ":bprevious<CR>", { desc = "Previous buffer"})
    vim.keymap.set('n', '<leader>fx', ":bdelete<CR>", { desc = "Close buffer"})
  end
}
