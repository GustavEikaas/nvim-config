local bindings = {}

function bindings.setup()
  vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
  vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, {})
  vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
  vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, {})
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
  vim.keymap.set("n", "<leader>ra", vim.lsp.buf.rename, {})
end

return bindings
