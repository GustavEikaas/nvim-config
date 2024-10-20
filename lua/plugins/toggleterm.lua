return {
  "akinsho/toggleterm.nvim",
  config = function()
    require("toggleterm").setup()
    vim.keymap.set({ 'n', 't' }, '<A-i>', function() require("toggleterm").toggle(1, nil, nil, "float") end)
    vim.keymap.set({ 'n', 't' }, '<A-h>', function() require("toggleterm").toggle(2, nil, nil, "horizontal") end)
  end,

}
