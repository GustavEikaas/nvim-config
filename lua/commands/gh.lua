local gh = {}

local cached = nil
--TODO: cache like hell and source cache when vim opens
local function get_main_or_master()
  if cached then
    return cached
  end
  vim.fn.system "git rev-parse main"
  if vim.v.shell_error ~= 0 then
    cached = "master"
    return cached
  end

  cached = "main"
  return cached
end

local function try_open_pr()
  local num = 0
  local spinner_frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }

  local notification = vim.notify(spinner_frames[1] .. " Looking up PR", "info", {
    timeout = false,
  })

  local pr_num
  vim.fn.jobstart("gh pr view --json number -q .number", {
    buffer_stdout = true,
    on_stdout = function(_a, b)
      num = num + 1
      local new_spinner = num % #spinner_frames
      notification = vim.notify(spinner_frames[new_spinner] .. " Looking up PR", "info", {
        replace = notification,
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
    end,
  })
end

gh.setup = function()
  vim.api.nvim_create_user_command("DiffClose", function()
    vim.cmd "DiffviewClose"
  end, {})

  vim.api.nvim_create_user_command("Dirty", function()
    vim.cmd "DiffviewOpen"
  end, {})

  vim.api.nvim_create_user_command("Diff", function()
    local base = get_main_or_master()
    vim.cmd("DiffviewOpen origin/" .. base)
  end, {})

  vim.keymap.set("n", "<A-.>", function()
    local base = get_main_or_master()
    vim.cmd("DiffviewOpen origin/" .. base)
  end, { nowait = true })

  vim.keymap.set("n", "<A-,>", function()
    vim.cmd("DiffviewOpen")
  end, { nowait = true })

  vim.api.nvim_create_user_command("Comments", function()
    vim.cmd "GhReviewComments"
  end, {})

  vim.api.nvim_create_user_command("FHistory", function()
    vim.cmd "DiffviewFileHistory %"
  end, {})

  vim.keymap.set("n", "<A-->", function()
    vim.cmd("DiffviewFileHistory %")
  end, { nowait = true })


  vim.api.nvim_create_user_command("Blame", function()
    require("gitsigns").toggle_current_line_blame()
  end, {})

  vim.api.nvim_create_user_command("PR", try_open_pr, {})
end

return gh
