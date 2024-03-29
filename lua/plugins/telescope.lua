return {
  {
    'nvim-telescope/telescope.nvim',
    event = "VeryLazy",
    config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set('n', '<leader>fw', builtin.live_grep, {})
      -- vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
      vim.keymap.set('n', '<leader><leader>', builtin.find_files, {})
      vim.keymap.set("n", "<leader>fz", builtin.current_buffer_fuzzy_find, {})
      vim.keymap.set("n", '<leader>fr', builtin.oldfiles, {})
      vim.keymap.set("n", '<leader>gt', builtin.git_status, {})
      vim.keymap.set("n", '<leader>gb', builtin.git_branches, {})
    end,
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  {
    'nvim-telescope/telescope-ui-select.nvim',
    event = "VeryLazy",
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
  },
  {
    "nvim-telescope/telescope-github.nvim",
    event = "VeryLazy",
    config = function()
      require("telescope").load_extension("gh")
      -- TODO: add keybinds
    end
  }
}
