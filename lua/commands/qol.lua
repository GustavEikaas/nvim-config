local qol = {}

qol.setup = function()
  vim.api.nvim_create_user_command('Q', function()
    vim.cmd("quitall")
  end, {})
end

return qol
