---@type blink.cmp.Source
local M = {}

local map_kind_to_cmp_lsp_kind = {
  F = 3, -- Function -> Function
  C = 5, -- Column -> Field
  A = 6, -- Alias -> Variable
  T = 7, -- Table -> Class
  R = 14, -- Reserved -> Keyword
  S = 19, -- Schema -> Folder
}

function M.new()
  return setmetatable({}, { __index = M })
end

function M:get_trigger_characters()
  return { 'Include="', "Include='", "Version='", 'Version="' }
end

function M:enabled()
  local filetypes = { "csproj", "fsproj", "xml" }
  local is_enabled = vim.tbl_contains(filetypes, vim.bo.filetype)
  return is_enabled
end

function M:get_completions(ctx, callback)
  local cursor_col = ctx.cursor[2]
  local line = ctx.line
  local word_start = cursor_col + 1

  local triggers = self:get_trigger_characters()
  while word_start > 1 do
    local char = line:sub(word_start - 1, word_start - 1)
    if vim.tbl_contains(triggers, char) or char:match "%s" then
      break
    end
    word_start = word_start - 1
  end
  -- Get text from word start to cursor
  local input = line:sub(word_start, cursor_col)

  if input ~= "" and input:match "[^0-9A-Za-z_]+" then
    input = ""
  end

  local transformed_callback = function(items)
    callback {
      context = ctx,
      is_incomplete_forward = true,
      is_incomplete_backward = true,
      items = items,
    }
  end

  -- local results = vim.api.nvim_call_function("vim_dadbod_completion#omni", { 0, input })
  local results = {}
  print(input)

  local _, col = unpack(vim.api.nvim_win_get_cursor(0))
  local current_line = vim.api.nvim_get_current_line()
  local before_cursor = current_line:sub(1, col)
  local package_completion_pattern = 'Include="[^"]*$'
  local version_completion_pattern = 'Version="[^"]*$'
  local inside_include = before_cursor:match(package_completion_pattern)
  local inside_version = before_cursor:match(version_completion_pattern)



  if inside_include then
    print "Include results"
    results = {
      { word = "System.Data", abbr = "System.Data", menu = "Include", info = "System Data Library", kind = "T" },
      { word = "System.Xml", abbr = "System.Xml", menu = "Include", info = "XML Library", kind = "T" },
    }
  elseif inside_version then
    results = {
      { word = "1.0.0", abbr = "1.0.0", menu = "Version", info = "Stable release", kind = "A" },
      { word = "2.0.0", abbr = "2.0.0", menu = "Version", info = "Latest version", kind = "A" },
    }
  else
    results = {
      { word = "Swashbuckle.Swagger", abbr = "Swagger", menu = "menu", info = "wtf", kind = "F" },
      { word = "Swashbuckle.SwaggerUI", abbr = "Swagger.UI", menu = "menu", info = "wtf", kind = "F" },
      { word = "Newtonsoft.JSON", abbr = "Newtonsoft.JSON", menu = "menu", info = "wtf", kind = "F" },
    }
  end

  if not results then
    transformed_callback {}
    return function() end
  end

  local by_word = {}
  for _, item in ipairs(results) do
    local key = item.word .. item.kind
    if by_word[key] == nil then
      by_word[key] = item
    end
  end
  local items = {} ---@type table<string,lsp.CompletionItem>

  for _, item in pairs(by_word) do
    table.insert(items, {
      label = item.abbr or item.word,
      dup = 0,
      insertText = item.word,
      labelDetails = item.menu and { description = item.menu } or nil,
      documentation = item.info or "",
      kind = map_kind_to_cmp_lsp_kind[item.kind] or vim.lsp.protocol.CompletionItemKind.Text,
    })
  end

  transformed_callback(items)

  return function() end
end

return M
