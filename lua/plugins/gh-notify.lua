return {
  dir = "C:\\Users\\Gustav\\repo\\gh-notify.nvim",
  config = function()
    require("gh-notify").setup({
      polling = true
    })
    vim.api.nvim_create_user_command('Sub', function()
      require("gh-notify"):start()
    end, {})
    vim.api.nvim_create_user_command('GhNot', function()
      require("gh-notify").list_messages()
    end, {})
  end
}
