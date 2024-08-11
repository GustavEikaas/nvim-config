return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = "Trouble",
  config = function()
    require("trouble").setup({
      modes = {
        lsp = {
          desc = "LSP definitions, references, implementations, type definitions, and declarations",
          sections = {
            "lsp_references",
            "lsp_definitions",
            "lsp_implementations",
            "lsp_type_definitions",
            "lsp_declarations",
          },
        },
      }
    })
  end,
  keys = {
    {
      "<leader>xx",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Buffer Diagnostics (Trouble)",
    },
    {
      "<leader>gr",
      "<cmd>Trouble lsp toggle focus=false win.position=bottom<cr>",
      desc = "LSP Definitions / references / ... (Trouble)",
    },
  },
}
