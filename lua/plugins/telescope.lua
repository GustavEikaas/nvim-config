return {
  {
	  'nvim-telescope/telescope.nvim',
	  config = function()
	    local builtin = require("telescope.builtin")
	    vim.keymap.set('n', '<leader>fw', builtin.live_grep, {})
	    vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
	  end,
	  dependencies = { 'nvim-lua/plenary.nvim' }
  },
  {
    'nvim-telescope/telescope-ui-select.nvim',
    config = function()
      require("telescope").setup {
      extensions = {
        ["ui-select"] = {
        require("telescope.themes").get_dropdown {
        }
        }
      }
    }
      require("telescope").load_extension("ui-select")
    end
  }
}
