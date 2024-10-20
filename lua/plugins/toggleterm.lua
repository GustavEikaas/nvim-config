return {
  "akinsho/toggleterm.nvim",
  config = function()
    require("toggleterm").setup()
    vim.keymap.set({ 'n', 't' }, '<A-i>', function() require("toggleterm").toggle(1, nil, nil, "float") end)
    vim.keymap.set({ 'n', 't' }, '<A-h>', function() require("toggleterm").toggle(2, nil, nil, "horizontal") end)

    function _G.set_terminal_keymaps()
      local opts = { buffer = 0 }
      vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
      vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
      vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
      vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
      vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
      vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
    end

    -- if you only want these mappings for toggle term use term://*toggleterm#* instead
    vim.cmd('autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()')
  end,
}
