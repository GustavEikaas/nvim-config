local function select(textobj)
  return function()
    require("nvim-treesitter-textobjects.select").select_textobject(textobj, "textobjects")
  end
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    branch = "main",
    build = ":TSUpdate",
    init = function()
      local parser_installed = {
        "python",
        "go",
        "c",
        "lua",
        "vim",
        "vimdoc",
        "query",
        "markdown_inline",
        "markdown",
        "c_sharp",
      }

      vim.defer_fn(function()
        require("nvim-treesitter").install(parser_installed)
      end, 1000)
      require("nvim-treesitter").update()

      vim.api.nvim_create_autocmd("FileType", {
        desc = "User: enable treesitter highlighting",
        callback = function(ctx)
          local hasStarted = pcall(vim.treesitter.start)

          local noIndent = {}
          if hasStarted and not vim.list_contains(noIndent, ctx.match) then
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = "nvim-treesitter/nvim-treesitter",
    branch = "main",

    opts = {
      select = {
        lookahead = true,
        include_surrounding_whitespace = false,
      },
    },
    keys = {
      -- MOVE
      -- {
      --   "<C-j>",
      --   function()
      --     local move = require "nvim-treesitter-textobjects.move"
      --     move.goto_next_start("@function.outer", "textobjects")
      --   end,
      --   desc = " Goto next function",
      -- },
      -- {
      --   "<C-k>",
      --   function()
      --     local move = require "nvim-treesitter-textobjects.move"
      --     move.goto_previous_start("@function.outer", "textobjects")
      --   end,
      --   desc = " Goto prev function",
      -- },

      -- TEXT OBJECTS
      { "a<CR>", select "@return.outer", mode = { "x", "o" }, desc = "↩ outer return" },
      { "i<CR>", select "@return.inner", mode = { "x", "o" }, desc = "↩ inner return" },
      { "aa", select "@parameter.outer", mode = { "x", "o" }, desc = "󰏪 outer arg" },
      { "ia", select "@parameter.inner", mode = { "x", "o" }, desc = "󰏪 inner arg" },
      { "iu", select "@loop.inner", mode = { "x", "o" }, desc = "󰛤 inner loop" },
      { "au", select "@loop.outer", mode = { "x", "o" }, desc = "󰛤 outer loop" },
      { "al", select "@call.outer", mode = { "x", "o" }, desc = "󰡱 outer call" },
      { "il", select "@call.inner", mode = { "x", "o" }, desc = "󰡱 inner call" },
      { "af", select "@function.outer", mode = { "x", "o" }, desc = " outer function" },
      { "if", select "@function.inner", mode = { "x", "o" }, desc = " inner function" },
      { "ao", select "@conditional.outer", mode = { "x", "o" }, desc = "󱕆 outer condition" },
      { "io", select "@conditional.inner", mode = { "x", "o" }, desc = "󱕆 inner condition" },
    },
  },
}
