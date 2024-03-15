-- Simple QOL bindings
vim.api.nvim_set_keymap("n", "<C-s>", ":w<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-s>", "<Esc>:w<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-c>", ":%y+<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Esc>", ":noh<CR>", { silent = true })

-- Reprogram brain
vim.api.nvim_set_keymap("n", "<Right>", "", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Left>", "", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Up>", "", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Down>", "", { noremap = true, silent = true })

-- Navigate splits
vim.api.nvim_set_keymap("n", "<C-k>", ":wincmd k<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-h>", ":wincmd h<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-j>", ":wincmd j<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-l>", ":wincmd l<CR>", { noremap = true, silent = true })

-- Resize splits
vim.keymap.set("n", "<C-A-l>", ":3winc ><CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-A-h>", ":3winc <<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-A-j>", ":res +3 <CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-A-k>", ":res -3 <CR>", { noremap = true, silent = true })

vim.keymap.set("i", "jj", "<Esc>", { noremap = true, silent = true })
vim.keymap.set("i", "<Esc>", "", { noremap = true, silent = true })

vim.keymap.set("i", "<C-l>", "<Esc>la", { noremap = true, silent = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true })
