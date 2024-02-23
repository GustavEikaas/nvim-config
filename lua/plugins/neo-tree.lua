return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    config = function()
    	vim.keymap.set('n', '<leader>e', ':Neotree filesystem reveal right<CR>', { silent = true })
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", 
      "MunifTanjim/nui.nvim",
    }
}
