local pyright = {}

function pyright.setup()
  local lspconfig = require("lspconfig")
  -- local capabilities = require('cmp_nvim_lsp').default_capabilities()
  lspconfig.pyright.setup({
    cmd = { "pyright-langserver", "--stdio" },
    -- capabilities = capabilities,
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
