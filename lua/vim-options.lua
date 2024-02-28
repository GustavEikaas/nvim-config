vim.cmd("set tabstop=2")
vim.cmd("set expandtab")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set relativenumber")
vim.cmd("set clipboard=unnamedplus")

vim.keymap.set("n", "<Right>", ":3winc ><CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<Left>", ":3winc <<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<Down>", ":res +3 <CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<Up>", ":res -3 <CR>", { noremap = true, silent = true })

vim.g.mapleader = " "
