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

  dap.adapters.coreclr = function(callback, config)
    callback { type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 }
  end
end

return M
