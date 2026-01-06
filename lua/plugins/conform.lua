return {
  "stevearc/conform.nvim",
  config = function()
    require("conform").setup {
      formatters_by_ft = {
        lua = { "stylua" },
        rust = { "rustfmt", lsp_format = "fallback" },
        javascript = { "prettierd", "prettier", lsp_format = "fallback", stop_after_first = true },
        vue = { "prettierd", "prettier", stop_after_first = true },
        cs = { lsp_format = "fallback" },
        typescript = { "prettierd", "prettier", lsp_format = "fallback", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", lsp_format = "fallback", stop_after_first = true },
      },
    }
    vim.keymap.set("n", "<leader>fm", require("conform").format, {})
  end,
}
