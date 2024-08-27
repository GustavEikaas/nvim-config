local function truncateText(text, maxLength)
  local truncatedText = text:sub(1, maxLength)
  if #text > maxLength then
    truncatedText = truncatedText .. "..."
  end
  return truncatedText
end

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  config = function()
    local status = require 'spotify.spotify'.status
    status:start()

    local debugger = {
      function()
        local dap = require("dap")
        return dap.status()
      end,
      color = { fg = "#FFFFFF", bg = "#1DB954" }
    }

    local copilot_status = ""

    local copilot_line = {
      function()
        return copilot_status
      end,
      color = { fg = "#FFFFFF", bg = "#D6ACFF" }
    }

    local fn = vim.schedule_wrap(function()
      local output = vim.fn.execute("Copilot status")
      local pattern = "Copilot: Ready"
      if string.match(output, pattern) then
        copilot_status = ""
      else
        copilot_status = ""
      end
    end)

    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "*",
      callback = function()
        fn()
      end,
    })

    local spotify_line = {
      function()
        local listen = status.listen()
        return truncateText(listen, 50)
      end,
      color = { fg = "#FFFFFF", bg = "#1DB954" }
    }
    local pin_indicator = {
      function()
        local cur_buf = vim.api.nvim_get_current_buf()
        return require("hbac.state").is_pinned(cur_buf) and "" or ""
      end,
      color = { fg = "#ef5f6b", gui = "bold" },
    }
    local buffer_line = {
      'buffers',
      max_length = vim.o.columns * 2 / 3,
      filetype_names = {
        TelescopePrompt = 'Telescope',
        dashboard = 'Dashboard',
        packer = 'Packer',
        fzf = 'FZF',
        alpha = 'Alpha',
        NvimTree = "Tree"
      },
      use_mode_colors = false,
      symbols = {
        modified = ' ●',
        alternate_file = '',
        directory = '',
      },
    }
    require("lualine").setup({
      options = {
        icons_enabled = true,
        theme = 'dracula',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = { statusline = { "NvimTree" }, winbar = { "NvimTree" } },
        ignore_focus = { "NvimTree" },
        always_divide_middle = true,
        globalstatus = true,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        }
      },
      sections = {
        lualine_a = { 'mode', debugger },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = {},
        lualine_x = { 'encoding', 'filetype' },
        lualine_y = { pin_indicator },
        lualine_z = { copilot_line, spotify_line }
      },
      tabline = { lualine_a = { buffer_line } },
      winbar = {},
      inactive_winbar = {},
      extensions = {}
    })
  end
}
