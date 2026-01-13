---@diagnostic disable-next-line: unused-local
local extensions = require "extensions"
require "vim-options"

require "general.use-pwsh"
require "general.reload-buf"
require "general.bindings"

require("commands.gh").setup()
require("commands.markdown").setup()
require("commands.todo").setup()
require("commands.js").setup()
require("commands.spotify").setup()
require("commands.qol").setup()

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

require("lazy").setup {
  spec = {
    import = "plugins",
  },
  change_detection = {
    enabled = false,
    notify = false,
  },
}
vim.cmd "filetype plugin on"
vim.lsp.enable "ts_ls"
vim.lsp.enable "yamlls"
vim.lsp.enable "lua_ls"
