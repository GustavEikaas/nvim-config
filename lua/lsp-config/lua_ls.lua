local lua_ls = {}

function lua_ls.setup()
  local lspconfig = require("lspconfig")
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  lspconfig.lua_ls.setup({
    cmd = require("extensions").isWindows() and { "lua-language-server.cmd", "--stdio" } or nil,
    capabilities = capabilities
  })
end

return lua_ls
