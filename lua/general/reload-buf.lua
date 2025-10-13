-- auto reload file when contents are written from an external source. e.g github reset --hard
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  callback = function()
    pcall(vim.cmd, "checktime")
  end,
})
