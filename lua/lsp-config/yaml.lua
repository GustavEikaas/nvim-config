local yaml = {}


function yaml.setup()
  local lspconfig = require("lspconfig")
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
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
          ["https://raw.githubusercontent.com/equinor/radix-operator/release/json-schema/radixapplication.json"] = "radixconfig.yaml"
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
end

return yaml
