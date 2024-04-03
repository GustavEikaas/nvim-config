local omnisharp = {}

function omnisharp.setup()
  local lspconfig = require("lspconfig")
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  -- MasonInstall omnisharp@v1.39.8
  lspconfig.omnisharp.setup({
    cmd = { "dotnet", vim.fn.stdpath "data" .. "/mason/packages/omnisharp/libexec/OmniSharp.dll" },
    capabilities = capabilities,
    enable_import_completion = true,
    organize_imports_on_format = true,
    enable_rozlyn_analyzers = true,
    enable_decompilation_support = true,
    enable_package_auto_restore = true,
    handlers = {
      ["textDocument/definition"] = require('omnisharp_extended').handler,
    },
  })
end

return omnisharp
