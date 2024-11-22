return {
  "luckasRanarison/tailwind-tools.nvim",
  enabled = not vim.g.is_perf,
  event = "LspAttach",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  opts = {} -- your configuration
}
