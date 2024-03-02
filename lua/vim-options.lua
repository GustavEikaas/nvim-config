vim.cmd("set tabstop=2")
vim.cmd("set expandtab")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set relativenumber")
vim.cmd("set clipboard=unnamedplus")

vim.keymap.set("n", "<C-A-l>", ":3winc ><CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-A-h>", ":3winc <<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-A-j>", ":res +3 <CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-A-k>", ":res -3 <CR>", { noremap = true, silent = true })

vim.g.mapleader = " "
