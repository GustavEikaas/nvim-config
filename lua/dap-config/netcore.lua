local M = {}

M.register_net_dap = function()
  local dap = require("dap")
  local cwd = vim.fn.getcwd()

  dap.listeners.before.event_terminated["easy-dotnet"] = function()
    -- Reset cwd when debugging stops
    vim.cmd("cd " .. cwd)
  end
  dap.listeners.before.event_exited["easy-dotnet"] = function()
    -- Reset cwd when debugging stops
    vim.cmd("cd " .. cwd)
  end

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
        vim.cmd("cd " .. dll.project_path)
        return dll.dll_path
      end,
    }
  }
  dap.adapters.coreclr = {
    type = "executable",
    command = "netcoredbg",
    args = { "--interpreter=vscode" },
  }
end

return M
