local powershell = {}

function powershell.setup()
  local capabilities = require('blink.cmp').get_lsp_capabilities()
  require("lspconfig").powershell_es.setup({
    shell = "powershell.exe",
    bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
    capabilities = capabilities
  })
end

return powershell
