local M = {}

M.register_net_dap = function()
  local dap = require "dap"
  local dotnet = require "easy-dotnet"

  dap.configurations["cs"] = {
    {
      type = "coreclr",
      name = "Program",
      request = "attach",
      select_project = dotnet.prepare_debugger,
    },
  }

  dap.adapters.coreclr = function(callback)
    callback { type = "server", host = "127.0.0.1", port = 8086 }
  end
end

return M
