return {
  -- Prevents the bufferline from junking up
  "axkirillov/hbac.nvim",
  config = function()
    local hbac = require("hbac")
    hbac.setup({
      autoclose                  = true,
      threshold                  = 1,
      close_command              = function(bufnr)
        vim.api.nvim_buf_delete(bufnr, {})
      end,
      close_buffers_with_windows = false,
    })

    vim.keymap.set("n", "<leader>a", function()
      hbac.toggle_pin()
      require("lualine").refresh()
    end, { noremap = true, silent = true })

    vim.keymap.set("n", "<C-x>", function()
      vim.cmd("Hbac unpin_all")
      vim.cmd("Hbac close_unpinned")
    end, { noremap = true, silent = true })
  end
}
