local M = {}

--- Rebuilds the project before starting the debug session
---@param co thread
local function rebuild_project(co, path)
  local spinner = require("easy-dotnet.ui-modules.spinner").new()
  spinner:start_spinner "Building"
  vim.fn.jobstart(string.format("dotnet build %s", path), {
    on_exit = function(_, return_code)
      if return_code == 0 then
        spinner:stop_spinner "Built successfully"
      else
        spinner:stop_spinner("Build failed with exit code " .. return_code, vim.log.levels.ERROR)
        error "Build failed"
      end
      coroutine.resume(co)
    end,
  })
  coroutine.yield()
end

M.register_net_dap = function()
  local dap = require "dap"
  local dotnet = require "easy-dotnet"
  local debug_dll = nil

  local function ensure_dll()
    if debug_dll ~= nil then
      return debug_dll
    end
    local dll = dotnet.get_debug_dll(true)
    debug_dll = dll
    return dll
  end

  for _, value in ipairs { "cs", "fsharp" } do
    dap.configurations[value] = {
      {
        type = "coreclr",
        name = "Program",
        request = "attach",
        -- env = function()
        --   local dll = ensure_dll()
        --   local vars = dotnet.get_environment_variables(dll.project_name, dll.relative_project_path)
        --   return vars or nil
        -- end,
        -- program = function()
        --   local dll = ensure_dll()
        --   local co = coroutine.running()
        --   rebuild_project(co, dll.project_path)
        --   return dll.relative_dll_path
        -- end,
        project = function()
          local dll = ensure_dll()
          vim.print(dll)
          return dll.absolute_project_path
        end,
      },
      {
        type = "coreclr",
        name = "Test",
        request = "attach",
        processId = function()
          local res = require("easy-dotnet").experimental.start_debugging_test_project()
          return res.process_id
        end,
      },
    }
  end

  dap.listeners.before["event_terminated"]["easy-dotnet"] = function()
    debug_dll = nil
  end

  dap.adapters.coreclr = function(callback, config)
    callback { type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 }
  end
  -- {
  --   type = "executable",
  --   command = "netcoredbg",
  --   args = { "--interpreter=vscode" },
  -- }
end

return M
