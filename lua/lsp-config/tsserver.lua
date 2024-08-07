local extensions = require("extensions")
local tsserver = {}

function tsserver.setup()
  local lspconfig = require("lspconfig")
  local capabilities = require('cmp_nvim_lsp').default_capabilities()

  lspconfig.tsserver.setup({
    cmd = { extensions.isWindows() and "typescript-language-server.cmd" or "typescript-language-server", "--stdio" },
    capabilities = capabilities
  })

  require 'lspconfig'.tailwindcss.setup(
    {
      cmd = { extensions.isWindows() and "tailwindcss-language-server.cmd" or "tailwindcss-language-server", "--stdio" },
      capabilities = capabilities
    })
end

return tsserver
