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

  vim.api.nvim_create_user_command('PR', function()
    local success, prNumber = pcall("gh pr view --json number -q .number")
    if success then
      vim.notify("PR " .. prNumber)
    else
      vim.notify("Failed to find pr")
    end
  end, {})
end



return gh
