-- Simple QOL bindings
vim.api.nvim_set_keymap("n", "<M-j>", ":m .+1<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<M-k>", ":m .-2<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-s>", ":w<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-s>", "<Esc>:w<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-c>", ":%y+<CR>", { noremap = true, silent = true })

