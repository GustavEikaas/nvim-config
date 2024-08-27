return
{ {
  "folke/neodev.nvim",
  config = function()
    require("neodev").setup({ library = { plugins = { "nvim-dap-ui" }, types = true }, })
  end
},
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
        ensure_installed = { "lua_ls", "tsserver", "powershell_es", "yamlls", "rust_analyzer" }
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("lsp-config.lua_ls").setup()
      require("lsp-config.tsserver").setup()
      require("lsp-config.powershell_es").setup()
      require("lsp-config.yaml").setup()
      require("lsp-config.rust-analyzer").setup()
      require("lsp-config.pyright").setup()
      require("lsp-config.bash").setup()
      require("lsp-config.fsharp").setup()
      -- bindings
      require("lsp-config.bindings").setup()
    end,
    dependencies = {
      "Hoffs/omnisharp-extended-lsp.nvim"
    }
  }
}
