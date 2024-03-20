local todo = {}
todo.setup = function()
  vim.api.nvim_create_user_command('Fix', function()
    vim.cmd("TodoTrouble keywords=FIX,HACK")
  end, {})
end

return todo
