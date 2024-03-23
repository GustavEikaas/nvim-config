local extensions = require "extensions"
local M = {}

M.get_project_from_csproj = function(csproj_file_path)
  local isWebProject = M.is_web_project(csproj_file_path)

  return {
    display = csproj_file_path,
    path = csproj_file_path,
    name = csproj_file_path,
    runnable = isWebProject,
    secrets = M.has_secrets(csproj_file_path)
  }
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


M.find_csproj_file = function()
  local currentDirectory = io.popen("cd"):read("*l"):gsub("\\", "/")
  local files = io.popen("dir /b \"" .. currentDirectory .. "\""):read("*a")

  for file in files:gmatch("[^\r\n]+") do
    if file:match("%.csproj$") then
      return currentDirectory .. "/" .. file
    end
  end

  return nil
end

return M
