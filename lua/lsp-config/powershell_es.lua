local powershell = {}

function powershell.setup()
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  require("lspconfig").powershell_es.setup({
    shell = "powershell.exe",
    bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
    capabilities = capabilities
  })
end

return powershell
