local M = {}

local function on_secret_selected(item)
  local home_dir = vim.fn.expand('~')
  local secret_path = home_dir .. '\\AppData\\Roaming\\Microsoft\\UserSecrets\\' .. item.secrets .. "\\secrets.json"
  vim.notify(secret_path)
  vim.cmd("edit " .. vim.fn.fnameescape(secret_path))
end

M.edit_secrets_picker = function()
  local extensions = require("extensions")
  local sln_parser = require("dotnet.sln-parse")
  local solutionFilePath = sln_parser.find_solution_file()
  if solutionFilePath == nil then
    vim.notify("No .sln file found")
  end

  local projectsWithSecrets = extensions.filter(sln_parser.get_projects_from_sln(solutionFilePath), function(i)
    return i.secrets ~= false and i.path ~= nil and i.runnable == true
  end)

  require("dotnet.picker").picker(nil, projectsWithSecrets, on_secret_selected)
end

return M
