return {
  "neovim/nvim-lspconfig",
  config = function()
    vim.lsp.enable "ts_ls"
    vim.lsp.enable "bashls"
    vim.lsp.enable "lua_ls"
    vim.lsp.enable "fsharp_language_server"
    vim.lsp.enable "yamlls"
    vim.lsp.enable "rust_analyzer"
    vim.lsp.enable "powershell_es"

    local capabilities = require("blink.cmp").get_lsp_capabilities()
    vim.lsp.config("*", {
      capabilities = capabilities,
    })
    vim.lsp.config("yamlls", {
      on_attach = function(client, _)
        client.server_capabilities.documentFormattingProvider = true
      end,
      settings = {
        yaml = {
          schemas = {
            ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
            ["https://json.schemastore.org/github-action.json"] = "/.github/actions/*",
            ["https://json.schemastore.org/github-issue-forms.json"] = "/.github/ISSUE_TEMPLATE/*",
            ["https://raw.githubusercontent.com/equinor/radix-operator/release/json-schema/radixapplication.json"] = "radixconfig.yaml",
          },
          trace = {
            server = "verbose",
          },
          format = {
            enable = true,
          },
        },
      },
    })

    vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
    -- trouble override
    vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, {})
    vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
    vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, {})
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
    vim.keymap.set("n", "<leader>ra", vim.lsp.buf.rename, {})
  end,
}
