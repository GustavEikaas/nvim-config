return {
  "vuki656/package-info.nvim",
  event = "BufEnter package.json",
  config = function()
    require("package-info").setup({
      package_manager = 'pnpm',
      autostart = false,
      hide_up_to_date = false
    })
  end
}
