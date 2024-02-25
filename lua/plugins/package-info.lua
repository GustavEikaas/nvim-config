return {
  "vuki656/package-info.nvim",
  event = "BufEnter",
  config = function()
    require("package-info").setup({
      package_manager = 'pnpm'
    })
    vim.api.nvim_set_keymap(
      "n",
      "<leader>ns",
      "<cmd>lua require('package-info').toggle({ force = true })<cr>",
      { silent = true, noremap = true }
    )
  end
}
