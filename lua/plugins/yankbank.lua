return {
  "ptdewey/yankbank-nvim",
  config = function()
    require('yankbank').setup()
    vim.keymap.set("n", "<leader>p", "<cmd>YankBank<CR>", { noremap = true })
  end,
}
