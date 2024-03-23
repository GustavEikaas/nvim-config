local M = {}

local function csproj_fallback(on_secret_selected)
  local csproj_path = require("dotnet.csproj-parse").find_csproj_file()
  if (csproj_path == nil) then
    vim.notify("No .sln or .csproj file found in cwd")
  end
  local csproj = require("dotnet.csproj-parse").get_project_from_csproj(csproj_path)
  if csproj.secrets == false then
    vim.notify(csproj_path .. " has no secret file")
    return
  end
  require("dotnet.picker").picker(nil, { csproj }, on_secret_selected, "Secrets")
  return
end


M.edit_secrets_picker = function(on_secret_selected)
  local extensions = require("extensions")
  local sln_parser = require("dotnet.sln-parse")
  local solutionFilePath = sln_parser.find_solution_file()
  if solutionFilePath == nil then
    csproj_fallback(on_secret_selected)
    return
  end

  local projectsWithSecrets = extensions.filter(sln_parser.get_projects_from_sln(solutionFilePath), function(i)
    return i.secrets ~= false and i.path ~= nil and i.runnable == true
  end)

  require("dotnet.picker").picker(nil, projectsWithSecrets, on_secret_selected, "Secrets")
end

return M
