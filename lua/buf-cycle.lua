local M = {
  ring_buf = vim.ringbuf(5)
}

M.setup = function()
  local hbac = require("hbac")

  hbac.setup({
    autoclose                  = true,
    threshold                  = 1,
    close_command              = function(bufnr)
      local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')
      if filetype == "octo" then
        return
      end
      M.ring_buf:push(vim.api.nvim_buf_get_name(bufnr))
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

  local function gotoprevbuf()
    local prev_buf = M.ring_buf:pop()
    if prev_buf == vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()) then
      gotoprevbuf()
    end
    if prev_buf then
      vim.cmd('edit ' .. vim.fn.fnameescape(prev_buf))
    else
      print("No buffer to restore.")
    end
  end

  vim.keymap.set("n", "<leader>T", function()
    gotoprevbuf()
  end, { noremap = true, silent = true })
end
return M
