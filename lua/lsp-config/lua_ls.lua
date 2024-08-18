local lua_ls = {}

function lua_ls.setup()
  local lspconfig = require("lspconfig")
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  lspconfig.lua_ls.setup({
    cmd = require("extensions").isWindows() and { "lua-language-server.cmd", "--stdio" } or nil,
    capabilities = capabilities,
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
          path = vim.split(package.path, ";"),
        },
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = { vim.env.VIMRUNTIME },
          checkThirdParty = false,
        },
        telemetry = {
          enable = false,
        },
      },
    },
  })
end

return lua_ls
