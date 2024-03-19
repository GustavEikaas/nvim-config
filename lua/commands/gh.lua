local gh = {}

local function try_open_pr()
  local handle = io.popen("gh pr view --json number -q .number")
  if handle == nil then
    return
  end
  local value = handle:read("n")
  handle:close()
  if value then
    vim.cmd("Octo pr edit " .. value)
  else
    vim.notify("Failed to find pr")
  end
end

local function git_restore_curr_buffer()
  local file_path = vim.fn.expand("%")
  local handle = io.popen("git restore --source=origin/main " .. file_path)
  if handle == nil then
    return
  end
  local value = handle:read("*a")
  handle:close()
  if value then
    vim.notify("File restored from main " .. value)
    vim.cmd("checktime")
  end
end

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

  vim.api.nvim_create_user_command("History", function()
    vim.cmd("DiffviewFileHistory %")
  end, {})

  vim.api.nvim_create_user_command("Blame", function()
    require("gitsigns").toggle_current_line_blame()
  end, {})

  vim.api.nvim_create_user_command('GGRF', git_restore_curr_buffer, {})

  vim.api.nvim_create_user_command('PR', try_open_pr, {})
end

return gh
