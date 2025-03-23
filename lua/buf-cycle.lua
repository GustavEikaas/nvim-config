local M = {
  buffer_list = {},
}

local function gracefully_delete_buffer(bufnr)
  if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
    if vim.api.nvim_buf_get_option(bufnr, "modified") then
      return
    end
    pcall(vim.api.nvim_buf_delete, bufnr, {})
  end
end

M.setup = function()
  local hbac = require "hbac"

  hbac.setup {
    autoclose = true,
    threshold = 1,
    close_command = function(bufnr)
      local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
      if filetype == "octo" then
        return
      end

      local buf_name = vim.api.nvim_buf_get_name(bufnr)

      local dupe = false
      for _, value in ipairs(M.buffer_list) do
        if value == buf_name then
          dupe = true
        end
      end

      if dupe == true then
        gracefully_delete_buffer(bufnr)
        return
      end

      if vim.tbl_contains(M.buffer_list, buf_name) then
        --prevent dupes
        return
      end
      table.insert(M.buffer_list, buf_name)

      if #M.buffer_list > 7 then
        table.remove(M.buffer_list) -- Remove last (oldest) element
      end

      gracefully_delete_buffer(bufnr)
    end,
    close_buffers_with_windows = false,
  }

  vim.keymap.set("n", "<leader>a", function()
    hbac.toggle_pin()
    require("lualine").refresh()
  end, { noremap = true, silent = true })

  vim.keymap.set("n", "<C-x>", function()
    vim.cmd "Hbac unpin_all"
    vim.cmd "Hbac close_unpinned"
  end, { noremap = true, silent = true })

  local function gotoprevbuf()
    local last_index = #M.buffer_list
    local prev_buf = M.buffer_list[last_index]
    local prev_table = {}
    local cur_buf = vim.api.nvim_get_current_buf()
    local curr_buf_would_close = not require("hbac.state").is_pinned(cur_buf)
    table.insert(prev_table, prev_buf)
    if curr_buf_would_close then
      table.insert(prev_table, vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()))
    end

    for _, value in ipairs(M.buffer_list) do
      if value ~= prev_buf and value ~= vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()) then
        table.insert(prev_table, value)
      end
    end
    M.buffer_list = prev_table

    vim.cmd("edit " .. vim.fn.fnameescape(prev_buf))
  end

  vim.keymap.set("n", "<leader>T", function()
    gotoprevbuf()
  end, { noremap = true, silent = true })
end

return M
