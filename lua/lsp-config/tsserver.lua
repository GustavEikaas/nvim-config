local tsserver = {}

function tsserver.setup()
  local lspconfig = require("lspconfig")
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  local platform = vim.loop.os_uname().sysname

  lspconfig.tsserver.setup({
    -- Doesnt work on arch
    cmd = { platform == "Windows" and "typescript-language-server.cmd" or "typescript-language-server", "--stdio" },
    capabilities = capabilities
  })
end

return tsserver
