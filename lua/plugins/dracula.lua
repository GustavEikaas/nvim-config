return {
  "Mofiqul/dracula.nvim",
  enabled = true,
  lazy = false,
  name = "dracula",
  priority = 1000,
  config = function()
    local dracula = require "dracula"
    local bright_red = "#FF6E6E"
    local bright_green = "#69FF94"
    local diff_add = "#1db954"
    local background = "#282A36"
    local selection = "#44475A"
    local bright_white = "#FFFFFF"
    local orange = "#FFB86C"
    local diff_text_color = "#0c0d10"
    dracula.setup {
      colors = {
        bg = background,
        fg = "#F8F8F2",
        selection = selection,
        comment = "#6272A4",
        red = "#FF5555",
        orange = orange,
        yellow = "#F1FA8C",
        green = "#50fa7b",
        purple = "#BD93F9",
        cyan = "#8BE9FD",
        pink = "#FF79C6",
        bright_red = bright_red,
        bright_green = bright_green,
        bright_yellow = "#FFFFA5",
        bright_blue = "#D6ACFF",
        bright_magenta = "#FF92DF",
        bright_cyan = "#A4FFFF",
        bright_white = bright_white,
        menu = "#21222C",
        visual = "#3E4452",
        gutter_fg = "#4B5263",
        nontext = "#3B4048",
        white = "#ABB2BF",
        black = "#191A21",
      },
      show_end_of_buffer = false, -- default false
      transparent_bg = true, -- default false
      lualine_bg_color = "#44475a", -- default nil
      italic_comment = true, -- default false
      overrides = {
        -- Diff
        OctoUser = { bg = "#22272E", fg = orange },
        DiffAdd = { bg = "#5B6081" },
        DiffDelete = { fg = "#A60204" },
        -- DiffText is the changed portion of a DiffChange
        DiffText = { fg = diff_text_color, bg = bright_green, bold = true },
        DiffChange = { fg = diff_text_color, bg = diff_add },
        OctoPullAdditions = { bg = "#273732" },
        OctoPullDeletions = { bg = "#362B31" },
        OctoPullModifications = { fg = orange },
        -- TS
        TreesitterContext = { bg = "#273732" },

        -- Notify
        NotifyBackground = { bg = bright_white },

        -- Dap
        DapStopped = { bg = selection },
        DapBreakpoint = { bg = "#362B31" },

        -- DBUI
        NotificationInfo = { bg = background },

        -- Illuminate
        IlluminatedWordRead = { bg = selection, underline = true },
        IlluminatedWordWrite = { bg = selection, underline = true },
        IlluminatedWordText = { bg = selection, underline = true },

        LspCodeLens = { fg = "#717171", italic = true },
      },
    }

    vim.cmd.colorscheme "dracula"
  end,
}
