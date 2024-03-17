local gh = {}

gh.setup = function()
  vim.api.nvim_create_user_command('DiffClose', function()
    vim.cmd("DiffviewClose")
  end, {})

  vim.api.nvim_create_user_command('Dirty', function()
    vim.cmd("DiffviewOpen HEAD")
  end, {})

  vim.api.nvim_create_user_command('Diff', function()
    vim.cmd("DiffviewOpen origin/main")
  end, {})

  vim.api.nvim_create_user_command('Prs', function()
    vim.cmd("Octo pr list")
  end, {})

  vim.api.nvim_create_user_command('Issues', function()
    vim.cmd("Octo issue list")
  end, {})



  vim.api.nvim_create_user_command('PR', function()
    local handle = io.popen("gh pr view --json number -q .number")
    local value = handle:read("l")
    handle:close()
    if value then
      vim.notify("PR " .. value)
      vim.cmd("Octo pr edit " .. value)
    else
      vim.notify("Failed to find pr")
    end
  end, {})
end



return gh
