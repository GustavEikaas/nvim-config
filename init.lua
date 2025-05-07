---@diagnostic disable-next-line: unused-local
local extensions = require "extensions"

require "general.use-pwsh"
require "general.reload-buf"
require "general.bindings"

require("commands.gh").setup()
require("commands.markdown").setup()
require("commands.todo").setup()
require("commands.lsp").setup()
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
require "vim-options"
require("lazy").setup "plugins"
vim.cmd "filetype plugin on"

local function wrap(callback)
  return function(...)
    -- Check if we are already in a coroutine
    if coroutine.running() then
      -- If already in a coroutine, call the callback directly
      callback(...)
    else
      -- If not, create a new coroutine and resume it
      local co = coroutine.create(callback)
      local s = ...
      local handle = function()
        local success, err = coroutine.resume(co, s)
        if not success then
          print("Coroutine failed: " .. err)
        end
      end
      handle()
    end
  end
end

vim.api.nvim_create_user_command("DotnetRunTest", function()

  -- string VSTestPath { get; init; }
  -- string DLLPath { get; init; }
  -- string OutFile { get; init; }
  local dllPath = "C:/Users/gusta/repo/NeovimDebugProject/NeovimDebugProject.Tests/bin/Debug/net9.0/NeovimDebugProject.Tests.dll"
  local vstestDll = 'C:/Program Files/dotnet/sdk/9.0.203/vstest.console.dll'
  local path = vim.fs.normalize(os.tmpname())
  require("msg").send("VSTest_Discover", { vsTestPath = vstestDll, dllPath = dllPath, outFile = path}, function(response)
    if response.error then
      vim.schedule(function()
        vim.notify(string.format("[%s]: %s", response.error.code, response.error.message), vim.log.levels.ERROR)
      end)
      return
    end
    vim.schedule(function()
      vim.print(response)
      local contents = vim.fn.readfile(path)
      vim.print(contents)
    end)
  end)
end, {})
