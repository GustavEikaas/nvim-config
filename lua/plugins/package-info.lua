return {
  "vuki656/package-info.nvim",
  -- Doesnt work with octo.nvim pr review
  enabled = false,
  event = "BufEnter package.json",
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
