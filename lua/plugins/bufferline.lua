return {
  {
    -- Prevents the bufferline from junking up
    "axkirillov/hbac.nvim",
    config = function()
      local hbac = require("hbac")
      hbac.setup({
        autoclose                  = true, -- set autoclose to false if you want to close manually
        threshold                  = 1,    -- hbac will start closing unedited buffers once that number is reached
        close_command              = function(bufnr)
          vim.api.nvim_buf_delete(bufnr, {})
        end,
        close_buffers_with_windows = false,
      })

      vim.keymap.set("n", "<leader>a", function()
        hbac.toggle_pin()
        require("lualine").refresh()
      end)

      vim.keymap.set("n", "<C-x>", function()
        vim.cmd("Hbac unpin_all")
        vim.cmd("Hbac close_unpinned")
      end, { noremap = true, silent = true })
    end
  },
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require("bufferline").setup({
        options = {
          themable = true,
          tab_size = 12,
          diagnostics = false,
          show_buffer_close_icons = false,
          show_buffer_icons = false,
          show_close_icon = false,
          separator_style = "thin",
          always_show_bufferline = true,
          hover = {
            enabled = false
          }
        }
      })
      vim.keymap.set("n", "<Tab>", ":BufferLineCycleNext<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { noremap = true, silent = true })
    end
  }
}
