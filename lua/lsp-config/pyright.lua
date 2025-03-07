local pyright = {}

function pyright.setup()
  local lspconfig = require("lspconfig")
  local capabilities = require('blink.cmp').get_lsp_capabilities()
  lspconfig.pyright.setup({
    cmd = { "pyright-langserver", "--stdio" },
    capabilities = capabilities,
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          diagnosticMode = "workspace",
          useLibraryCodeForTypes = false,
          typeCheckingMode = "off",
        },
      },
    }
  })
end

return pyright
