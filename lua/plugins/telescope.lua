return {
  {
    'nvim-telescope/telescope.nvim',
    event = "VeryLazy",
    config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set('n', '<leader>fw', builtin.live_grep, {})
      vim.keymap.set('n', '<leader><leader>', builtin.find_files, {})
      vim.keymap.set("n", "<leader>fz", builtin.current_buffer_fuzzy_find, {})
    end,
    dependencies = { 'nvim-lua/plenary.nvim' }
  }
}
