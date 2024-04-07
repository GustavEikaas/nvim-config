local bash = {}

function bash.setup()
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  require("lspconfig").bashls.setup({
    capabilities = capabilities
  })
end

return bash
