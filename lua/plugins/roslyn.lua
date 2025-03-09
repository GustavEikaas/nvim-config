local function send_did_create_notification(file_path)
  local client = vim.lsp.get_clients({ name = "roslyn" })[1]
  if not client then
    return
  end

  local uri = vim.uri_from_fname(file_path)
  local params = { changes = { { type = 1, uri = uri } } }
  client.notify("workspace/didChangeWatchedFiles", params)
end

local function is_buffer_empty(buf)
  for i = 1, vim.api.nvim_buf_line_count(buf), 1 do
    local line = vim.api.nvim_buf_get_lines(buf, i, i + 1, false)[1]
    if line ~= "" and line ~= nil then
      return false
    end
  end

  return true
end

return {
  "seblj/roslyn.nvim",
  config = function()
    require("roslyn").setup({
      config = {
        settings = {
          ["csharp|background_analysis"] = {
            dotnet_compiler_diagnostics_scope = "fullSolution"
          },
          ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
            csharp_enable_inlay_hints_for_lambda_parameter_types = true,
            csharp_enable_inlay_hints_for_types = true,
            dotnet_enable_inlay_hints_for_indexer_parameters = true,
            dotnet_enable_inlay_hints_for_literal_parameters = true,
            dotnet_enable_inlay_hints_for_object_creation_parameters = true,
            dotnet_enable_inlay_hints_for_other_parameters = true,
            dotnet_enable_inlay_hints_for_parameters = true,
            dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
          },
          ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
          },
        }
      },
      filewatching = false,
    })

    vim.api.nvim_create_autocmd("BufRead", {
      pattern = "*.cs",
      callback = function()
        local buf = vim.api.nvim_get_current_buf()
        if not is_buffer_empty(buf) then
          return
        end

        local file_path = vim.api.nvim_buf_get_name(buf)
        send_did_create_notification(file_path)
      end,
    })
  end,
}
