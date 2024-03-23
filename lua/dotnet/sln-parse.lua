local extensions = require "extensions"
local M = {}

M.get_projects_from_sln = function(solutionFilePath)
  local file = io.open(solutionFilePath, "r")

  if not file then
    error("Failed to open file " .. solutionFilePath)
  end
  local regexp = 'Project%("{(.-)}"%).*= "(.-)", "(.-)", "{.-}"'

  local projectLines = extensions.filter(file:lines(), function(line)
    local id, name, path = line:match(regexp)
    if id and name and path then
      return true
    end
    return false
  end)

  local projects = extensions.map(projectLines, function(line)
    local id, name, path = line:match(regexp)
    return {
      display = name,
      name = name,
      path = path,
      id = id,
      runnable = M.is_web_project(path),
      secrets = M.has_secrets(path)
    }
  end)
  file:close()

  return projects
end

M.has_secrets = function(project_file_path)
  local pattern = "<UserSecretsId>([a-fA-F0-9%-]+)</UserSecretsId>"
  local file = io.open(project_file_path, "r")
  if not file then
    return false, "File not found or cannot be opened"
  end

  local contains_secrets = extensions.find(file:lines(), function(line)
    local value = line:match(pattern)
    if value then
      return true
    end
    return false
  end)

  return (contains_secrets and contains_secrets:match(pattern)) or false
end

M.is_web_project = function(project_file_path)
  local file = io.open(project_file_path, "r")
  if not file then
    return false, "File not found or cannot be opened"
  end

  local contains_sdk_web = extensions.any(file:lines(),
    function(line) return line:find('<Project%s+Sdk="Microsoft.NET.Sdk.Web"') end)

  file:close()

  return contains_sdk_web
end


M.find_solution_file = function()
  local currentDirectory = io.popen("cd"):read("*l"):gsub("\\", "/")
  local files = io.popen("dir /b \"" .. currentDirectory .. "\""):read("*a")

  for file in files:gmatch("[^\r\n]+") do
    if file:match("%.sln$") then
      return currentDirectory .. "/" .. file
    end
  end

  return nil
end

return M
