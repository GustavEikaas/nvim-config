local js = {}

js.setup = function()
  vim.api.nvim_create_user_command('Packages', function()
    require("package-info").toggle()
  end, {})
end

return js
