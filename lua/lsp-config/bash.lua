local bash = {}

function bash.setup()
  local capabilities = require('blink.cmp').get_lsp_capabilities()
  require("lspconfig").bashls.setup({
    capabilities = capabilities
  })
end

return bash
