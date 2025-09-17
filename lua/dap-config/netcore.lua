local M = {}

M.register_net_dap = function()
  local dap = require "dap"
  local dotnet = require "easy-dotnet"

  dap.configurations["cs"] = {
    {
      type = "coreclr",
      name = "Program",
      request = "attach",
      launch_args = function()
        local res = dotnet.prepare_debugger(false)
        return {
          project = res.path,
          targetFramework = res.target_framework_moniker,
          configuration = res.configuration,
          launchProfile = res.launch_profile,
        }
      end,
    },
  }

  dap.adapters.coreclr = function(callback, config)
    callback { type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 }
  end
end

return M
