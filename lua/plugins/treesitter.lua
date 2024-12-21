return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local config = require("nvim-treesitter.configs")
      config.setup({
       auto_install = true,
       ensure_installed = { "c_sharp" },
        highlight = { enable = true },
        indent = { enable = true },
        textobjects = {
          select = {
            enable = true,
            include_surrounding_whitespace = true,
          },
        },
      })
    end
  }
