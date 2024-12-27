-- Enable smart indenting
vim.opt.smartindent = true
vim.opt.shiftwidth = 2
vim.opt.breakindent = true

vim.cmd("set timeoutlen=1000 ttimeoutlen=0")

-- Better splitting
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Disable text wrap
vim.opt.wrap = false

-- Enable persistent undo history
vim.opt.undofile = true

-- Set tabs to 2 spaces
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.softtabstop = 2

-- Always show signcolumn
vim.opt.signcolumn = "yes"

vim.opt.foldcolumn = "0"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
vim.opt.foldmethod = "indent"

-- Use system clipboard
vim.schedule(function() vim.opt.clipboard = "unnamedplus"end)

-- Show relative numbers
vim.opt.relativenumber = true
vim.opt.number = true

-- Scroll offset, always keep 8 lines above or below when scrolling
vim.opt.scrolloff = 8

-- Highlight current line
vim.opt.cursorline = true

-- Set leader to <space>
vim.g.mapleader = " "

--History stuff
--Store 20 marks per file
--Store 50 commands
vim.opt.shada = "'20,\"20,h"


-- Better diff view
vim.opt.fillchars:append { diff = "╱" }

-- Remap C-s to save the buffer
vim.api.nvim_set_keymap('n', '<C-s>', ':w<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-s>', '<Esc>:w', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', 'jj', '<Esc>', { noremap = true, silent = true })

