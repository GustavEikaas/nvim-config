return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({})
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "tsserver", "omnisharp", "powershell_es", "yamlls" }
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")

      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      lspconfig.lua_ls.setup({
        cmd = { "lua-language-server.cmd", "--stdio" },
        capabilities = capabilities
      })

      lspconfig.yamlls.setup({
        capabilities = capabilities,
        on_attach = function(client, _)
          client.server_capabilities.documentFormattingProvider = true
        end,
        settings = {
          yaml = {
            schemas = {
              ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
              ["https://json.schemastore.org/github-action.json"] = "/.github/actions/*",
              ["https://json.schemastore.org/github-issue-forms.json"] = "/.github/ISSUE_TEMPLATE/*",
            },
            format = {
              enable = true
            },
            schemaStore = {
              enable = true
            }
          }
        }
      })
      lspconfig.tsserver.setup({
        cmd = { "typescript-language-server.cmd", "--stdio" },
        capabilities = capabilities
      })
      require("lspconfig").powershell_es.setup({
        shell = "powershell.exe",
        bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
        capabilities = capabilities
      })
      lspconfig.omnisharp.setup({
        cmd = { "dotnet", vim.fn.stdpath "data" .. "/mason/packages/omnisharp/libexec/OmniSharp.dll" },
        capabilities = capabilities,
        enable_import_completion = true,
        organize_imports_on_format = true,
        enable_rozlyn_analyzers = true,
        enable_decompilation_support = true,
        handlers = {
          ["textDocument/definition"] = require('omnisharp_extended').handler,
        },
      })
      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
      vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, {})
      vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, {})
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
    end,
    dependencies = {
      "Hoffs/omnisharp-extended-lsp.nvim"
    }
  }
}
