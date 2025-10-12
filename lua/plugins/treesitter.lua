return {

  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup {
        opts = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = false,
        },
      }
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
  },

  -- {
  --   "nvim-treesitter/nvim-treesitter-textobjects",
  --   branch = "main",
  --   config = function()
  --     require("nvim-treesitter.configs").setup {
  --       highlight = { enable = true },
  --       indent = { enable = true },
  --       autotag = {
  --         enable = true,
  --         enable_close = true,
  --         enable_rename = true,
  --         enable_close_on_slash = false,
  --       },
  --       textobjects = {
  --         select = {
  --           enable = true,
  --           lookahead = true,
  --           keymaps = {
  --             ["af"] = "@function.outer",
  --             ["if"] = "@function.inner",
  --             ["ac"] = "@class.outer",
  --             ["ic"] = "@class.inner",
  --           },
  --           selection_modes = {
  --             ["@parameter.outer"] = "v",
  --             ["@function.outer"] = "V",
  --             ["@class.outer"] = "<c-v>",
  --           },
  --           include_surrounding_whitespace = true,
  --         },
  --       },
  --     }
  --   end,
  -- },
}
