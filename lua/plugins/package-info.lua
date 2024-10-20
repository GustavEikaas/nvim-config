return {
  "vuki656/package-info.nvim",
  enabled = not vim.g.is_perf,
  event = "BufEnter package.json",
  config = function()
    require("package-info").setup({
      package_manager = 'pnpm',
      autostart = false,
      hide_up_to_date = true
    })
  end
}
