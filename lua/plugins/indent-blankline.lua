return {
  "lukas-reineke/indent-blankline.nvim",
  enabled = not vim.g.is_perf,
  event = "BufRead",
  main = "ibl",
  opts = {}
}
