local M = {}

M.get_debug_dll = function()
  local extensions = require("extensions")
  local sln_parse = require("dotnet.sln-parse")
  local sln_file = sln_parse.find_solution_file()
  local dll = sln_file ~= nil and M.get_dll_for_solution_project(sln_file) or M.get_dll_for_csproject_project()

  vim.notify("Started debugging " .. dll)
  print(dll)
  return dll
end

M.get_dll_for_solution_project = function(sln_file)
  local extensions = require("extensions")
  local sln_parse = require("dotnet.sln-parse")
  local projects = sln_parse.get_projects_from_sln(sln_file)

  local dll_name = extensions.find(projects, function(i)
    return i.runnable == true
  end)
  if dll_name == false or dll_name == nil then
    error("No runnable projects found")
  end
  local path = dll_name.path
  local lastIndex = path:find("[^/]*$")
  local newPath = path:sub(1, lastIndex - 1)
  local dll = extensions.find(extensions.find_file_recursive(dll_name.name, 10, newPath), function(i)
    return string.find(i, "/bin") ~= nil
  end) .. ".dll"

  return dll
end

M.get_dll_for_csproject_project = function()
  local extensions = require("extensions")
  local csproj_parse = require("dotnet.csproj-parse")
  local project_file = csproj_parse.find_csproj_file()
  if project_file == nil then
    error("No project or solution file found")
  end
  local left_part = string.match(project_file, "(.-)%.")

  local dll = extensions.find(extensions.find_file_recursive(left_part, 10, "."), function(i)
    return string.find(i, "/bin") ~= nil
  end) .. ".dll"

  return dll
end

return M
