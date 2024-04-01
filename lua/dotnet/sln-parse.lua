local extensions = require "extensions"
local M = {}

local function normalize_path(path)
  return vim.fn.getcwd() .. "/" .. path:gsub("\\", "/")
end

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
      path = normalize_path(path),
      id = id,
      runnable = M.is_web_project(normalize_path(path)),
      secrets = M.has_secrets(normalize_path(path))
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

local function find_sln_files_linux()
  local files = {}
  local handle = io.popen('ls *.sln 2>/dev/null')
  if handle then
    for file in handle:lines() do
      table.insert(files, file)
    end
    handle:close()
  end
  return files[1]
end

local function find_sln_files_windows()
  local currentDirectory = io.popen("cd"):read("*l"):gsub("\\", "/")
  local files = io.popen("dir /b \"" .. currentDirectory .. "\""):read("*a")

  for file in files:gmatch("[^\r\n]+") do
    if file:match("%.sln$") then
      return currentDirectory .. "/" .. file
    end
  end

  return nil
end

M.find_solution_file = function()
  local platform = vim.loop.os_uname().sysname
  return platform == "Windows_NT" and find_sln_files_windows() or find_sln_files_linux()
end

return M
