-- All the extension methods I never wanna write twice
local E = {
  tables = {}
}
-- Tables
local function filter_table(tbl, cb)
  local results = {}
  for _, item in ipairs(tbl) do
    if cb(item) then
      table.insert(results, item)
    end
  end

  return results
end

local function filter_iterator(tbl, cb)
  local results = {}
  for line in tbl do
    if cb(line) then
      table.insert(results, line)
    end
  end
  return results
end

E.filter = function(tbl, cb)
  local table_type = type(tbl)
  if table_type == "function" then
    -- Assume it's an iterator, e.g., file:lines()
    return filter_iterator(tbl, cb)
  elseif table_type == "table" then
    -- Assume it's a normal Lua table
    return filter_table(tbl, cb)
  else
    -- Unexpected type
    error("Expected function or table, received: " .. table_type)
  end
end

local function map_table(tbl, cb)
  local results = {}
  for _, item in ipairs(tbl) do
    table.insert(results, cb(item))
  end
  return results
end

local function map_iterator(tbl, cb)
  local results = {}
  for line in tbl do
    table.insert(results, cb(line))
  end
  return results
end

E.map = function(tbl, cb)
  local table_type = type(tbl)
  if table_type == "function" then
    -- Assume it's an iterator, e.g., file:lines()
    return map_iterator(tbl, cb)
  elseif table_type == "table" then
    -- Assume it's a normal Lua table
    return map_table(tbl, cb)
  else
    -- Unexpected type
    error("Expected function or table, received: " .. table_type)
  end
end

local function foreach_table(tbl, cb)
  for index, item in ipairs(tbl) do
    cb(item, index)
  end
end

local function foreach_iterator(tbl, cb)
  for line in tbl do
    cb(line)
  end
end

E.foreach = function(tbl, cb)
  local table_type = type(tbl)
  if table_type == "function" then
    -- Assume it's an iterator, e.g., file:lines()
    return foreach_iterator(tbl, cb)
  elseif table_type == "table" then
    -- Assume it's a normal Lua table
    return foreach_table(tbl, cb)
  else
    -- Unexpected type
    error("Expected function or table, received: " .. table_type)
  end
end

local function any_table(tbl, cb)
  for _, item in ipairs(tbl) do
    if cb(item) then
      return true
    end
  end
  return false
end

local function any_iterator(tbl, cb)
  for line in tbl do
    if cb(line) then
      return true
    end
  end
  return false
end

E.any = function(tbl, cb)
  local table_type = type(tbl)
  if table_type == "function" then
    -- Assume it's an iterator, e.g., file:lines()
    return any_iterator(tbl, cb)
  elseif table_type == "table" then
    -- Assume it's a normal Lua table
    return any_table(tbl, cb)
  else
    -- Unexpected type
    error("Expected function or table, received: " .. table_type)
  end
end
local function find_table(tbl, cb)
  for _, item in ipairs(tbl) do
    if cb(item) then
      return item
    end
  end
  return false
end

local function find_iterator(tbl, cb)
  for line in tbl do
    if cb(line) then
      return line
    end
  end
  return false
end

E.find = function(tbl, cb)
  local table_type = type(tbl)
  if table_type == "function" then
    -- Assume it's an iterator, e.g., file:lines()
    return find_iterator(tbl, cb)
  elseif table_type == "table" then
    -- Assume it's a normal Lua table
    return find_table(tbl, cb)
  else
    -- Unexpected type
    error("Expected function or table, received: " .. table_type)
  end
end
local function every_table(tbl, cb)
  for _, item in ipairs(tbl) do
    if not cb(item) then
      return false
    end
  end
  return true
end

local function every_iterator(tbl, cb)
  for line in tbl do
    if not cb(line) then
      return false
    end
  end
  return true
end

E.every = function(tbl, cb)
  local table_type = type(tbl)
  if table_type == "function" then
    -- Assume it's an iterator, e.g., file:lines()
    return every_iterator(tbl, cb)
  elseif table_type == "table" then
    -- Assume it's a normal Lua table
    return every_table(tbl, cb)
  else
    -- Unexpected type
    error("Expected function or table, received: " .. table_type)
  end
end

return E
