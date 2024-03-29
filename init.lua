local extensions = require("extensions")

require "general.use-pwsh"
require "general.reload-buf"
require "general.bindings"

require "commands.gh".setup()
require "commands.markdown".setup()
require "commands.todo".setup()
require "commands.lsp".setup()
require "commands.js".setup()
require "commands.spotify".setup()

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

require "dotnet.dotnet".setup({
  run_project = {
    on_select = function(selectedItem)
      local term = require("nvterm.terminal")
      term.send("dotnet run --project " .. selectedItem.path .. "\r\n", "float")
    end
  }
})
