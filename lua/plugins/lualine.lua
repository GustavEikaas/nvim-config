return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  config = function()
    local debugger = {
      function()
        local dap = require "dap"
        local status = dap.status()
        if status and status ~= "" then
          return status
        end
        return ""
      end,
      color = { fg = "#FFFFFF", bg = "#1DB954" },
    }
    local sln = {
      function()
        if debugger[1]() ~= "" then
          return ""
        end
        local solution = require("easy-dotnet").try_get_selected_solution()
        if solution and solution.basename then
          return string.format("󰘐 %s", vim.fn.fnamemodify(solution.path, ":t:r"))
        end
        return ""
      end,
      color = { fg = "#282a36", bg = "#bd93f9", gui = "bold" },
    }

    local function is_fzf_open()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local ft = vim.api.nvim_buf_get_option(buf, "filetype")
        if ft == "fzf" then
          return true
        end
      end
      return false
    end

    local job_indicator = {
      function()
        if is_fzf_open() then
          return ""
        end
        return require("easy-dotnet.ui-modules.jobs").lualine()
      end,
    }

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
        lualine_a = { "mode", debugger, sln },
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
