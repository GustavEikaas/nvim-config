local M = {
  ---@type table<number, table<string, string | "pending">>
  pretty_cache = {},
}

local primitives = {
  "bool",
  "string",
  "int",
  "float",
  "double",
}

local list_primitive = {
  "bool[]",
  "System.Collections.Generic.List<bool>",
  "string[]",
  "System.Collections.Generic.List<string>",
  "int[]",
  "System.Collections.Generic.List<int>",
  "float[]",
  "System.Collections.Generic.List<float>",
  "double[]",
  "System.Collections.Generic.List<double>",
}

local dict_like = {
  "System.Collections.Generic.Dictionary<string, string>",
  "System.Collections.Generic.Dictionary<string, int>",
  "System.Collections.Generic.Dictionary<int, string>",
  "System.Collections.Generic.IDictionary<string, string>",
  "System.Collections.Generic.IDictionary<string, int>",
  "System.Collections.Generic.IDictionary<int, string>",
}

local anon_like = {
  "<>f__AnonymousType0<string, int>",
}

local tuple_like = {
  "System.Tuple<int, int>",
}

local function fetch_variables(variables_reference, depth, callback)
  local dap = require "dap"
  local session = dap.session()
  if not session then
    callback {}
    return
  end

  session:request("variables", { variablesReference = variables_reference }, function(err, response)
    if err or not response or not response.variables then
      callback {}
      return
    end

    local result = {}
    local pending = #response.variables

    if pending == 0 then
      callback(result)
      return
    end

    for _, var in ipairs(response.variables) do
      local entry = {
        name = var.name,
        value = var.value,
        type = var.type,
        variablesReference = var.variablesReference,
        children = nil,
      }

      if var.variablesReference ~= 0 and depth > 0 then
        fetch_variables(var.variablesReference, depth - 1, function(child_vars)
          entry.children = child_vars
          pending = pending - 1
          if pending == 0 then
            table.insert(result, entry)
            callback(result)
          else
            table.insert(result, entry)
          end
        end)
      else
        table.insert(result, entry)
        pending = pending - 1
        if pending == 0 then
          callback(result)
        end
      end
    end
  end)
end

local function pretty_print_tuple(vars)
  local items = vim.tbl_filter(function(v)
    return v.name:match "^Item%d+$"
  end, vars)

  local values = vim.tbl_map(function(v)
    return v.value
  end, items)
  return "(" .. table.concat(values, ", ") .. ")"
end

local function pretty_print_var_ref(var_ref, var_type, cb)
  fetch_variables(var_ref, 2, function(vars)
    -- vars is list of child variables of the evaluated variable

    -- Detect if it's a List<string> backing object:
    -- Try to find the backing array field (_items or Items)
    local backing_array_var = nil
    local size = nil
    for _, v in ipairs(vars) do
      if size and backing_array_var then
        break
      end

      if v.name == "_items" or v.name == "Items" or v.name == "_array" then
        backing_array_var = v
      elseif v.name == "_size" then
        size = tonumber(v.value)
      end
    end

    if backing_array_var and backing_array_var.variablesReference and backing_array_var.variablesReference ~= 0 then
      fetch_variables(backing_array_var.variablesReference, 1, function(array_elements)
        local effective_elements = array_elements
        if size and size > 0 and size <= #array_elements then
          effective_elements = {}
          for i = 1, size do
            table.insert(effective_elements, array_elements[i])
          end
        end

        local pretty = table.concat(
          vim.tbl_map(function(c)
            return c.value
          end, effective_elements),
          ", "
        )
        cb(pretty)
      end)
    -- Handle AnonymousType0<string, any> as key-value structure
    elseif vim.tbl_contains(anon_like, var_type) then
      local entries = vim.tbl_map(function(v)
        return string.format("%s: %s", v.name, v.value)
      end, vars)
      cb(table.concat(entries, ", "))
    elseif vim.tbl_contains(tuple_like, var_type) then
      cb(pretty_print_tuple(vars))
    elseif vim.tbl_contains(dict_like, var_type) then
      local pairs = {}
      local pending = #vars

      if pending == 0 then
        cb ""
        return
      end

      for _, entry in ipairs(vars) do
        if entry.children and #entry.children > 0 then
          for _, mid_child in ipairs(entry.children) do
            if mid_child.children and #mid_child.children > 0 then
              local key, value = nil, nil
              for _, kv in ipairs(mid_child.children) do
                if kv.name == "key" or kv.name == "Key" then
                  key = kv.value
                elseif kv.name == "value" or kv.name == "Value" then
                  value = kv.value
                end
              end
              if key then
                table.insert(pairs, string.format("%s: %s", key, value or "null"))
              end
            end
          end
        end

        pending = pending - 1
        if pending == 0 then
          cb(table.concat(pairs, ", "))
        end
      end
    else
      -- Default: treat as flat array/list
      local pretty = table.concat(
        vim.tbl_map(function(c)
          return c.value
        end, vars),
        ", "
      )
      cb(pretty)
    end
  end)
end

--- Resolves and pretty-prints a debugger variable by name and type.
---
--- If the result has already been cached (per `id`), it is returned immediately.
--- Otherwise, it will evaluate the variable using the DAP session and invoke the callback (if provided).
---
--- @param id number The stack frame `id` used to scope the cache.
--- @param var_name string The evaluated name passed to the debugger.
---                        Typically set via `variable.evaluateName` or `variable.name`.
--- @param var_type string The variable type, e.g., `"System.Collections.Generic.List<string>"`.
--- @param cb fun(result: string|false)? Optional callback function to receive the result.
---                                      - If successful: receives a formatted string.
---                                      - If failed/unhandled: receives `false`.
--- @return string|false|nil If cached, returns the cached result immediately (string or false).
---                          If not cached and a callback is used, returns nil and calls the callback asynchronously.
function M.resolve(id, var_name, var_type, cb)
  local dap = require "dap"

  M.pretty_cache[id] = M.pretty_cache[id] or {}

  local cache = M.pretty_cache[id]

  if cache[var_name] and cache[var_name] ~= "pending" then
    return cache[var_name]
  end

  if
    (
      vim.tbl_contains(tuple_like, var_type)
      or vim.tbl_contains(dict_like, var_type)
      or vim.tbl_contains(anon_like, var_type)
      or vim.tbl_contains(list_primitive, var_type)
    ) and cache[var_name] ~= "pending"
  then
    cache[var_name] = "pending"
    dap.session():request("evaluate", { expression = var_name, context = "hover" }, function(err, response)
      if err or not response or not response.variablesReference then
        cache[var_name] = nil
        vim.schedule(function()
          vim.notify("No variable reference found for: " .. var_name)
        end)
        if cb then
          cb(false)
        end
        return
      end

      pretty_print_var_ref(response.variablesReference, var_type, function(pretty_str)
        cache[var_name] = pretty_str
        if cb then
          return cb(pretty_str)
        end
      end)
    end)
  else
    return false
  end

  return "pending"
end

return M
