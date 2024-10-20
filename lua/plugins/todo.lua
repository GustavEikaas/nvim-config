return {
  "folke/todo-comments.nvim",
  event = "VeryLazy",
  enabled = not vim.g.is_perf,
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {}
}
