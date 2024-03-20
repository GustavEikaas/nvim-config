local lsp = {}

lsp.setup = function()
  vim.api.nvim_create_user_command('Err', function()
    vim.cmd("Trouble")
  end, {})

  vim.api.nvim_create_user_command('RS', function()
    vim.cmd("LspRestart")
  end, {})
end

return lsp
