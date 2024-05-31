return {
  "akinsho/toggleterm.nvim",
  config = function()
    require("toggleterm").setup()
    vim.keymap.set({ 'n', 't' }, '<A-i>', function() require("toggleterm").toggle(nil, nil, nil, "float") end)
  end,

}
