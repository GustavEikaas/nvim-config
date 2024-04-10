-- Adds auto complete for issues and people tagging
vim.keymap.set("i", "@", "@<C-x><C-o>", { silent = true, buffer = true })
vim.keymap.set("i", "#", "#<C-x><C-o>", { silent = true, buffer = true })

local function watch_checks()
  local num = 0;
  local spinner_frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }

  local notification = vim.notify(spinner_frames[1] .. "Watching checks...", "info", {
    timeout = false,
  })

  local finalStatus = nil
  vim.fn.jobstart("gh pr checks --watch", {
    on_stdout = function(_, b)
      num = num + 1
      local checks = {}
      for _, value in pairs(b) do
        local name, status, url = value:match("(%S+)%s+(%S+)%s+(%S+)")
        if name and status and url then
          table.insert(checks, name .. " " .. status == 0 and "Pending" or status .. " " .. url)
        end
      end

      local notifyText = table.concat(checks, "\n")
      if #notifyText > 0 then
        finalStatus = notifyText
        notification = vim.notify(spinner_frames[num] .. "\n" .. notifyText, "info",
          { replace = notification })
      end
    end,
    stdout_buffered = false,
    on_exit = function(_, return_code)
      if return_code == 0 then
        vim.notify("All checks passed✅", "info", { replace = notification, timeout = 1000 })
      else
        vim.notify("", "info", { replace = notification, timeout = 1 })
        vim.notify("Checks failed🛑" .. "\n" .. finalStatus, "error", { timeout = 4000 })
      end
      vim.fn.jobstart("gh pr view --json mergeStateStatus --jq .mergeStateStatus", {
        stdout_buffered = true,
        on_stdout = function(_, b)
          if b[1] == "BLOCKED" then
            vim.notify(b[1], "error")
          else
            vim.notify(b[1], "info")
          end
        end
      })
    end,
  })
end


vim.keymap.set("n", "<leader>wc", function()
  watch_checks()
end, { silent = true, buffer = true })
