local M = {}

M.setup = function()
  local lspconfig = require 'lspconfig'
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  lspconfig.fsautocomplete.setup {
    cmd = require("extensions").isWindows() and { "fsautocomplete.cmd", "--stdio" } or nil,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    }
  }
end

return M
