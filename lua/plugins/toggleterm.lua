return {
  "akinsho/toggleterm.nvim",
  config = function()
    require("toggleterm").setup()
    vim.keymap.set({ 'n', 't' }, '<A-i>', function() vim.cmd("ToggleTerm direction=float name=PWSH") end)
  end,

}
