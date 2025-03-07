local tsserver = {}

function tsserver.setup()
  local lspconfig = require("lspconfig")
  local capabilities = require('blink.cmp').get_lsp_capabilities()

  lspconfig["ts_ls"].setup({
    cmd = { "typescript-language-server", "--stdio" },
    capabilities = capabilities
  })

end

return tsserver
