return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("trouble").setup()
    vim.keymap.set("n", "<leader>gr", function() require("trouble").toggle("lsp_references") end)
    vim.keymap.set("n", "<leader>xx", function() require("trouble").toggle() end)
  end
}
