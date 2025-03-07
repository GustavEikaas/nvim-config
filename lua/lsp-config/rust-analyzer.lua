local rust_analyzer = {}


function rust_analyzer.setup()
  local lspconfig = require("lspconfig")
  local capabilities = require('blink.cmp').get_lsp_capabilities()
  lspconfig.rust_analyzer.setup({
    capabilities = capabilities,
    bundle_path = vim.fn.stdpath("data") .. "/mason/packages/rust_analyzer/rust_analyzer.exe",
    settings = {
      ["rust-analyzer"] = {
        diagnostics = {
          enable = false
        }
      }
    }
  })
end

return rust_analyzer
