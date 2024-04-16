local M = {}

--- Rebuilds the project before starting the debug session
---@param co thread
local function rebuild_project(co)
  local num = 0;
  local spinner_frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }

  local notification = vim.notify(spinner_frames[1] .. " Building", "info", {
    timeout = false,
  })

  vim.fn.jobstart("dotnet build .", {
    on_stdout = function(a)
      num = num + 1
      local new_spinner = (num) % #spinner_frames
      notification = vim.notify(spinner_frames[new_spinner] .. " Building", "info",
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

local function merge_tables(table1, table2)
  local merged = {}
  for k, v in pairs(table1) do
    merged[k] = v
  end
  for k, v in pairs(table2) do
    merged[k] = v
  end
  return merged
end

M.register_net_dap = function()
  local dap = require("dap")
  local cwd = vim.fn.getcwd()
  local restart_cwd = nil

  dap.configurations.cs = {
    {
      type = "coreclr",
      name = "launch - netcoredbg",
      request = "launch",
      env = {
        ["ASPNETCORE_ENVIRONMENT"] = "DEVELOPMENT"
      },
      program = function()
        local dll = require("easy-dotnet").get_debug_dll()
        restart_cwd = dll.project_path
        vim.cmd("cd " .. dll.project_path)
        local vars = require("easy-dotnet").get_environment_variables(dll.project_name)
        if vars ~= nil then
          dap.configurations.cs[1].env = merge_tables(dap.configurations.cs[1].env, vars)
        end
        -- local shouldRebuild = vim.fn.input("Do you want to rebuild? Y/N:  ")
        -- if shouldRebuild == "Y" then
        local co = coroutine.running()
        rebuild_project(co)
        -- end

        return dll.dll_path
      end,
    }
  }
  dap.adapters.coreclr = {
    type = "executable",
    command = "netcoredbg",
    args = { "--interpreter=vscode" },
  }

  local function on_dap_exit()
    vim.cmd("cd " .. cwd)
  end

  dap.listeners.before.event_terminated["reset-cwd"] = on_dap_exit
  dap.listeners.before.event_exited["reset-cwd"] = on_dap_exit

  return function()
    if restart_cwd then
      vim.cmd("cd " .. restart_cwd)
      dap.listeners.after.event_terminated["handle_restart"] = nil
    end
  end
end

return M
