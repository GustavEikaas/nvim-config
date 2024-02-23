return {
	'nvim-telescope/telescope.nvim',
	config = function()
	  local builtin = require("telescope.builtin")
	  vim.keymap.set('n', '<leader>fw', builtin.live_grep, {})
	  vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
	end,
	dependencies = { 'nvim-lua/plenary.nvim' }
}
