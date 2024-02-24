-- Simple QOL bindings
vim.api.nvim_set_keymap("n", "<C-s>", ":w<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-s>", "<Esc>:w<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-c>", ":%y+<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Esc>", ":noh<CR>", { silent = true })
