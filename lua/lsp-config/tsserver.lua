local tsserver = {}

function tsserver.setup()
  local lspconfig = require("lspconfig")
  -- local capabilities = require('cmp_nvim_lsp').default_capabilities()

  lspconfig["ts_ls"].setup({
    cmd = { "typescript-language-server", "--stdio" },
    -- capabilities = capabilities
  })

end

return tsserver
