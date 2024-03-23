local M = {}

M.run_project_picker = function(on_select)
  local extensions = require("extensions")
  local sln_parser = require("dotnet.sln-parse")
  local solutionFilePath = sln_parser.find_solution_file()
  if solutionFilePath == nil then
    vim.notify("No .sln file found")
    return
  end
  local projects = extensions.filter(sln_parser.get_projects_from_sln(solutionFilePath), function(i)
    return i.runnable == true
  end)
  require("dotnet.picker").picker(nil, projects, on_select, "Run project")
end

return M
