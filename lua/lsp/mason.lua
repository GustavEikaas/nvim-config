return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({})
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    event = "BufEnter", 
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "tsserver", "omnisharp", "powershell_es", "yamlls", "rust_analyzer" }
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    event = "BufEnter",
    config = function()
      require("lsp-config.lua_ls").setup()
      require("lsp-config.tsserver").setup()
      require("lsp-config.omnisharp").setup()
      require("lsp-config.powershell_es").setup()
      require("lsp-config.yaml").setup()
      require("lsp-config.rust-analyzer").setup()
      -- bindings
      require("lsp-config.bindings").setup()
    end,
    dependencies = {
      "Hoffs/omnisharp-extended-lsp.nvim"
    }
  }
}
