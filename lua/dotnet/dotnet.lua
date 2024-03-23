local M = {}

M.setup = function()
  local commands = {
    secrets = function()
      require("dotnet.secrets").edit_secrets_picker()
    end,
    run = function()
      require("dotnet.run_project").run_project_picker()
    end
  }

  _G.handle_dotnet_command = function(...)
    local args = { ... }
    local subcommand = table.remove(args, 1)
    local func = commands[subcommand]
    if func then
      func()
    else
      print("Invalid subcommand:", subcommand)
    end
  end

  vim.api.nvim_command('command! -nargs=* Dotnet lua handle_dotnet_command(<f-args>)')

  vim.keymap.set("n", "<C-p>", function()
    require("dotnet.run_project").run_project_picker()
  end)

  vim.api.nvim_create_user_command('Dotnet secrets', function()
    require("dotnet.secrets").edit_secrets_picker()
  end, {})
end



return M
