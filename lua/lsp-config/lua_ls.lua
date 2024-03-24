local lua_ls = {}

function lua_ls.setup()
  local lspconfig = require("lspconfig")
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  lspconfig.lua_ls.setup({
    -- Doesnt work on linux
    -- cmd = { "lua-language-server.cmd", "--stdio" },
    capabilities = capabilities
  })
end

return lua_ls
