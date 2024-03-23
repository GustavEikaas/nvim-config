local M = {}

M.run_project_picker = function(on_select)
  local extensions = require("extensions")
  local sln_parser = require("dotnet.sln-parse")
  local solutionFilePath = sln_parser.find_solution_file()
  if solutionFilePath == nil then
    local csproj_path = require("dotnet.csproj-parse").find_csproj_file()
    if (csproj_path == nil) then
      vim.notify("No .sln file or .csproj file found")
    end
    require("dotnet.picker").picker(nil, { { name = csproj_path, display = csproj_path, path = csproj_path } }, on_select,
      "Run project")
    return
  end
  local projects = extensions.filter(sln_parser.get_projects_from_sln(solutionFilePath), function(i)
    return i.runnable == true
  end)
  require("dotnet.picker").picker(nil, projects, on_select, "Run project")
end

return M
