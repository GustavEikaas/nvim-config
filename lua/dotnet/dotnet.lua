local M = {}

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

M.setup = function(opts)
  local merged_opts = merge_tables(require("dotnet.options"), opts or {})
  local commands = {
    secrets = function()
      require("dotnet.secrets").edit_secrets_picker(merged_opts.secrets.on_select)
    end,
    run = function()
      require("dotnet.run_project").run_project_picker(merged_opts.run_project.on_select)
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
end

return M
