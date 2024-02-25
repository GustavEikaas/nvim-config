local tsserver = {}

function tsserver.setup()
  local lspconfig = require("lspconfig")
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  lspconfig.tsserver.setup({
    cmd = { "typescript-language-server.cmd", "--stdio" },
    capabilities = capabilities
  })
end

return tsserver
