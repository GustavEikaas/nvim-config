require "general.use-pwsh"
require "general.reload-buf"
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)
require("vim-options")
require("lazy").setup "plugins"


vim.api.nvim_set_keymap("n", "<M-j>", ":m .+1<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<M-k>", ":m .-2<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-s>", ":w<CR>", { noremap = true, silent = true })

-- import QOL snippets
-- require "general.auto-nvim-tree"
