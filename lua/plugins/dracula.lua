return {
  "Mofiqul/dracula.nvim",
  enabled = true,
  lazy = false,
  name = "dracula",
  priority = 1000,
  config = function()
    local dracula = require("dracula")
    dracula.setup({
      colors = {
        bg = "#282A36",
        fg = "#F8F8F2",
        selection = "#44475A",
        comment = "#6272A4",
        red = "#FF5555",
        orange = "#FFB86C",
        yellow = "#F1FA8C",
        green = "#50fa7b",
        purple = "#BD93F9",
        cyan = "#8BE9FD",
        pink = "#FF79C6",
        bright_red = "#FF6E6E",
        bright_green = "#69FF94",
        bright_yellow = "#FFFFA5",
        bright_blue = "#D6ACFF",
        bright_magenta = "#FF92DF",
        bright_cyan = "#A4FFFF",
        bright_white = "#FFFFFF",
        menu = "#21222C",
        visual = "#3E4452",
        gutter_fg = "#4B5263",
        nontext = "#3B4048",
        white = "#ABB2BF",
        black = "#191A21",
      },
      show_end_of_buffer = false,    -- default false
      transparent_bg = true,        -- default false
      lualine_bg_color = "#44475a", -- default nil
      italic_comment = true,        -- default false
      overrides = {
        DiffAdd = { bg = "#273732" },
        DiffDelete = { bg = "#362B31" },
        DiffChange = { fg = "#FFB86C" },
        OctoPullAdditions = { bg = "#273732"},
        OctoPullDeletions = { bg = "#362B31"},
        OctoPullModifications = { fg = "#FFB86C"},
        TreesitterContext = { bg = "#273732" },
        OctoUser = { bg = "#22272E", fg = "#FFB86C" },
        NotifyBackground = { bg = "#FFFFFF"}
      },
    })
    vim.cmd.colorscheme "dracula"
  end,
}
