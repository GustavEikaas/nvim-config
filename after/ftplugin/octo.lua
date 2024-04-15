-- Adds auto complete for issues and people tagging
vim.keymap.set("i", "@", "@<C-x><C-o>", { silent = true, buffer = true })
vim.keymap.set("i", "#", "#<C-x><C-o>", { silent = true, buffer = true })
vim.keymap.set("n", "<leader>c", function()
  vim.cmd("Octo pr checks")
end, { silent = true, buffer = true })
