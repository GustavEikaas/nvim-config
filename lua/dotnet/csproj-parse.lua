local extensions = require "extensions"
local M = {}

-- Function to find the corresponding .csproj file
M.get_dll_name_for_current_buffer = function()
  local root = extensions.get_git_root()
  local bufferPath = extensions.get_current_buffer_path()

  local function contains_csproj(directory)
    local cmd = string.format("find %s -maxdepth 1 -type f -name '*.csproj'", directory)
    local handle = io.popen(cmd)
    local result = handle:read("*a")
    handle:close()
    return result ~= ""
  end

  -- Traverse up the directory tree until .csproj file is found or git root toplevel is reached
  while bufferPath ~= "/" do
    if contains_csproj(bufferPath) then
      local dll_name = extensions.get_last_sub_path(bufferPath) .. ".dll"
      local dll = extensions.find(extensions.find_file_recursive(dll_name, 10, bufferPath), function(i)
        return string.find(i, "/bin") ~= nil
      end)
      return dll
    elseif bufferPath == root then
      break
    end
    bufferPath = bufferPath:match("(.+)/") -- Move up one directory
  end

  -- If .csproj file is not found and git root toplevel is reached, return nil
  vim.notify("No dll found")
  return nil
end

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


local function find_csproj_files_linux()
  local files = {}
  local handle = io.popen('ls *.csproj 2>/dev/null')
  if handle then
    for file in handle:lines() do
      table.insert(files, file)
    end
    handle:close()
  end
  if (#files > 1) then
    vim.notify("More than one solution file found")
  end
  return files[1]
end

local function find_csproj_files_windows()
  local currentDirectory = io.popen("cd"):read("*l"):gsub("\\", "/")
  local files = io.popen("dir /b \"" .. currentDirectory .. "\""):read("*a")

  for file in files:gmatch("[^\r\n]+") do
    if file:match("%.csproj$") then
      return currentDirectory .. "/" .. file
    end
  end

  return nil
end

M.find_csproj_file = function()
  return require("extensions").isWindows() and find_csproj_files_windows() or find_csproj_files_linux()
end

return M
