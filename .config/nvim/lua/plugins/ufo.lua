return {
    {
      'kevinhwang91/nvim-ufo',
      dependencies = 'kevinhwang91/promise-async',
      config = function()
        require('ufo').setup({
            provider_selector = function(bufnr, filetype, buftype)
                return {'treesitter', 'indent'}
            end
        })
        -- Keymaps for folding
        -- 'zo' opens a fold, 'zc' closes a fold
        vim.keymap.set("n", "<leader>o", "zo", { desc = "Open current fold" })
        vim.keymap.set("n", "<leader>c", "zc", { desc = "Close current fold" })

        vim.keymap.set("n", "<leader>O", "zR", { desc = "Open all fold" })
        vim.keymap.set("n", "<leader>C", "zM", { desc = "Close all fold" })

        -- Optional: Add a toggle map (very common in IDEs)
        vim.keymap.set("n", "<leader>z", "za", { desc = "Toggle current fold" })
      end
    },
}
