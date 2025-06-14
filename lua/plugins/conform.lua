return {
  "stevearc/conform.nvim",
  config = function()
    require("conform").setup {
      formatters_by_ft = {
        lua = { "stylua" },
        rust = { "rustfmt", lsp_format = "fallback" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        cs = { lsp_format = "fallback" },
      },
    }
    vim.keymap.set("n", "<leader>fm", require("conform").format, {})
  end,
}
