return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  config = function()
    local debugger = {
      function()
        local dap = require "dap"
        return dap.status()
      end,
      color = { fg = "#FFFFFF", bg = "#1DB954" },
    }

    local job_indicator = { require("easy-dotnet.ui-modules.jobs").lualine }

    local pin_indicator = {
      function()
        local cur_buf = vim.api.nvim_get_current_buf()
        return require("hbac.state").is_pinned(cur_buf) and "" or ""
      end,
      color = { fg = "#ef5f6b", gui = "bold" },
    }

    local buffer_line = {
      "buffers",
      max_length = vim.o.columns * 2 / 3,
      filetype_names = {
        TelescopePrompt = "Telescope",
        dashboard = "Dashboard",
        packer = "Packer",
        fzf = "FZF",
        alpha = "Alpha",
        NvimTree = "Tree",
      },
      use_mode_colors = false,
      symbols = {
        modified = " ●",
        alternate_file = "",
        directory = "",
      },
    }

    require("lualine").setup {
      options = {
        icons_enabled = true,
        theme = "dracula",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = { statusline = { "NvimTree", "neo-tree" }, winbar = { "NvimTree", "neo-tree" } },
        ignore_focus = { "NvimTree", "neo-tree" },
        always_divide_middle = true,
        globalstatus = true,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
      },
      sections = {
        lualine_a = { "mode", debugger },
        lualine_b = { job_indicator },
        lualine_c = {},
        lualine_x = { "encoding", "filetype" },
        lualine_y = { pin_indicator },
        lualine_z = {},
      },
      tabline = { lualine_a = { buffer_line }, lualine_z = {} },
      winbar = {},
      inactive_winbar = {},
      extensions = {},
    }
  end,
}
