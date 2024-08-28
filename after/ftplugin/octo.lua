vim.keymap.set("n", "<leader>c", function()
  vim.cmd("Octo pr checks")
end, { silent = true, buffer = true })
