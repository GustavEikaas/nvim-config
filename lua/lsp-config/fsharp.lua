local M = {}

M.setup = function()
  local lspconfig = require 'lspconfig'
  local capabilities = require('blink.cmp').get_lsp_capabilities()
  lspconfig.fsautocomplete.setup {
    cmd = { "fsautocomplete", "--stdio" },
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    }
  }
end

return M
