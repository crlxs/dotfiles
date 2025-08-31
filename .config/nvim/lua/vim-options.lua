vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")

vim.g.mapleader = " "
vim.g.maplocalleader = "//"

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "number"

-- Share nvim clipboard with Windows, yanking also copies to windows clipboard
vim.opt.clipboard = "unnamedplus"
