local gh = {}

local function try_open_pr()
  local num = 0;
  local spinner_frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }

  local notification = vim.notify(spinner_frames[1] .. " Looking up PR", "info", {
    timeout = false
  })

  local pr_num
  vim.fn.jobstart("gh pr view --json number -q .number", {
    buffer_stdout = true,
    on_stdout = function(_a, b)
      num = num + 1
      local new_spinner = (num) % #spinner_frames
      notification = vim.notify(spinner_frames[new_spinner] .. " Looking up PR", "info", {
        replace = notification
      })
      local val = b[1]
      if #val > 0 then
        pr_num = val
      end
    end,
    on_exit = function(_a, b)
      if b == 0 and pr_num then
        vim.notify("Opening PR " .. pr_num, "info", { replace = notification, timeout = 1000 })
        vim.cmd("Octo pr edit " .. pr_num)
      else
        vim.notify("", "info", { replace = notification, timeout = 1 })
        vim.notify("Failed to find pr", "error", { timeout = 1000 })
      end
    end
  })
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

  vim.api.nvim_create_user_command('PR', try_open_pr, {})
end

return gh
