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

  vim.api.nvim_create_user_command('Comments', function()
    vim.cmd("GhReviewComments")
  end, {})

  vim.api.nvim_create_user_command('GGRF', function()
    local file_path = vim.fn.expand("%")
    local handle = io.popen("git restore --source=origin/main " .. file_path)
    local value = handle:read("*a")
    handle:close()
    if value then
      vim.notify("File restored from main " .. value)
      vim.cmd("checktime")
    end
  end, {})

  vim.api.nvim_create_user_command('PR', function()
    local handle = io.popen("gh pr view --json number -q .number")
    local value = handle:read("n")
    handle:close()
    if value then
      vim.cmd("Octo pr edit " .. value)
    else
      vim.notify("Failed to find pr")
    end
  end, {})
end



return gh
