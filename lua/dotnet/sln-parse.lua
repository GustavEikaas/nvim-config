local extensions = require "extensions"
local M = {}

local function normalize_path(path, slnpath)
  return slnpath .. "/" .. path:gsub("\\", "/")
end

M.get_projects_from_sln = function(solutionFilePath)
  local file = io.open(solutionFilePath, "r")
  local slnpath = extensions.remove_filename_from_path(solutionFilePath)
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
      path = normalize_path(path, slnpath),
      id = id,
      runnable = M.is_web_project(normalize_path(path, slnpath)),
      secrets = M.has_secrets(normalize_path(path, slnpath))
    }
  end)
  file:close()
  return projects
end

M.has_secrets = function(project_file_path)
  if string.find(project_file_path, "%.") == nil then
    return false
  end
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
  if string.find(project_file_path, "%.") == nil then
    return false
  end

  local file = io.open(project_file_path, "r")
  if not file then
    vim.notify("Failed to open project file " .. project_file_path)
    return false, "File not found or cannot be opened"
  end

  local contains_sdk_web = extensions.any(file:lines(),
    function(line) return line:find('<Project%s+Sdk="Microsoft.NET.Sdk.Web"') end)

  file:close()

  return contains_sdk_web
end

M.find_solution_file = function()
  local file = require("plenary.scandir").scan_dir({ ".", "./src" }, { search_pattern = "%.sln$" })
  return file[1]
end

return M
