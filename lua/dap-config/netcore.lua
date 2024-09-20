local M = {}

--- Rebuilds the project before starting the debug session
---@param co thread
local function rebuild_project(co, path)
  local num = 0;
  local spinner_frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }

  local notification = vim.notify(spinner_frames[1] .. " Building", "info", {
    timeout = false,
  })

  vim.fn.jobstart(string.format("dotnet build %s", path), {
    on_stdout = function(a)
      num = num + 1
      local new_spinner = (num) % #spinner_frames
      notification = vim.notify(spinner_frames[new_spinner + 1] .. " Building", "info",
        { replace = notification })
    end,
    on_exit = function(_, return_code)
      if return_code == 0 then
        vim.notify("Built successfully", "info", { replace = notification, timeout = 1000 })
      else
        -- HACK: clearing previous building progress message
        vim.notify("", "info", { replace = notification, timeout = 1 })
        vim.notify("Build failed with exit code " .. return_code, "error", { timeout = 1000 })
        error("Build failed")
      end
      coroutine.resume(co)
    end,
  })
  coroutine.yield()
end

M.register_net_dap = function()
  local dap = require("dap")
  local dotnet = require("easy-dotnet")
  local debug_dll = nil

  local function ensure_dll()
    if debug_dll ~= nil then
      return debug_dll
    end
    local dll = dotnet.get_debug_dll()
    debug_dll = dll
    return dll
  end

  for _, value in ipairs({ "cs", "fsharp" }) do
    dap.configurations[value] = {
      {
        type = "coreclr",
        name = "Program",
        request = "launch",
        env = function()
          local dll = ensure_dll()
          local vars = dotnet.get_environment_variables(dll.project_name, dll.relative_project_path)
          return vars or nil
        end,
        program = function()
          local dll = ensure_dll()
          local co = coroutine.running()
          rebuild_project(co, dll.project_path)
          return dll.relative_dll_path
        end,
        cwd = function()
          local dll = ensure_dll()
          return dll.relative_project_path
        end
      },
      {
        type = "coreclr",
        name = "Test",
        request = "attach",
        processId = function()
          local res = require("easy-dotnet").experimental.start_debugging_test_project()
          print(vim.inspect(res))
          vim.notify("debugging: " .. res.process_id)
          return res.process_id
        end
      }
    }
  end

  dap.listeners.before['event_terminated']['easy-dotnet'] = function()
    debug_dll = nil
  end

  dap.adapters.coreclr = {
    type = "executable",
    command = "netcoredbg",
    args = { "--interpreter=vscode" },
  }
end

return M
