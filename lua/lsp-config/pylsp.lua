local python_lsp = {}

function python_lsp.setup()
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  require("lspconfig").pylsp.setup({
    cmd = { vim.fn.stdpath("data") .. "/mason/bin/pylsp.cmd" },
    capabilities = capabilities
  })
end

return python_lsp
