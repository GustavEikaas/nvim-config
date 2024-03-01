local bindings = {}

function bindings.setup()
  vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
  -- trouble override
  -- vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
  vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
  vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, {})
  vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, {})
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
  vim.keymap.set("n", "<leader>ra", vim.lsp.buf.rename, {})
  vim.keymap.set("n", "<C-z>", vim.lsp.buf.signature_help, {})
  vim.keymap.set("i", "<C-z>", vim.lsp.buf.signature_help, {})
end

return bindings
