return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  config = function()
    local status = require 'spotify.spotify'.status
    status:start()

    require("lualine").setup({
      options = {
        icons_enabled = true,
        theme = 'dracula',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
          statusline = { "NvimTree" },
          winbar = { "NvimTree" },
        },
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
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'filetype' },
        lualine_y = {
          {
            function()
              local cur_buf = vim.api.nvim_get_current_buf()
              return require("hbac.state").is_pinned(cur_buf) and "📍" or ""
              -- tip: nerd fonts have pinned/unpinned icons!
            end,
            color = { fg = "#ef5f6b", gui = "bold" },
          }
        },
        lualine_z = { status.listen }
      },
      tabline = {},
      winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
      },
      inactive_winbar = {},
      extensions = {}
    })
  end
}
