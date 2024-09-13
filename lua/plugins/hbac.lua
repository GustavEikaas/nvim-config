return {
  -- Prevents the bufferline from junking up
  "axkirillov/hbac.nvim",
  -- enabled = false,
  config = function()
    local hbac = require("hbac")
    local last_buffer_path = nil

    hbac.setup({
      autoclose                  = true,
      threshold                  = 1,
      close_command              = function(bufnr)
        local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')
        if filetype == "octo" then
          return
        end
        last_buffer_path = vim.api.nvim_buf_get_name(bufnr)
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

    vim.keymap.set("n", "<leader>T", function()
      if last_buffer_path and #last_buffer_path > 0 then
        vim.cmd('edit ' .. vim.fn.fnameescape(last_buffer_path))
      else
        print("No buffer to restore.")
      end
    end, { noremap = true, silent = true })
  end
}
