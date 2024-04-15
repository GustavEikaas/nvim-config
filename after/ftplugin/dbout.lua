-- Easily close dbout windows
vim.keymap.set("n", "q", function()
  vim.cmd("q")
end, { silent = true, buffer = true })
