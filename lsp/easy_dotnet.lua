---@type vim.lsp.Config
return {
  on_attach = function() end,
  settings = {
    ["csharp|formatting"] = {
      dotnet_organize_imports_on_format = true,
    },
  },
}
