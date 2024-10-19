return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  enabled = not vim.g.is_perf,
  cmd = "Trouble",
  config = function()
    require("trouble").setup({
      auto_close = true,
      auto_preview = true,
      auto_jump = true,
      modes = {
        lsp_base = {
          params = {
            include_current = false,
          },
        },
        lsp_references = {
          params = {
            include_declaration = false,
          },
        },
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
      "<cmd>Trouble lsp_references toggle focus=false win.position=bottom<cr>",
      desc = "LSP Definitions / references / ... (Trouble)",
    },
  },
}
