local M = {
  opts = {
    status = {
      update_interval = 10000,
      format = '%s %t'
    }
  },
  status = {},
  _status_line = ""
}

function M.status:start()
  local function force_update()
    local cmd = "spt playback --status --format '" .. M.opts.status.format .. "'"
    vim.fn.jobstart(cmd, { on_stdout = self.on_event, stdout_buffered = true })
  end
  local function toggle_playback()
    vim.fn.jobstart("spt playback --toggle", {
      on_exit = function()
        force_update()
      end
    })
  end

  local function prev_song()
    vim.fn.jobstart("spt playback --previous", {
      on_exit = function()
        force_update()
      end
    })
  end

  local function next_song()
    vim.fn.jobstart("spt playback --next", {
      on_exit = function()
        force_update()
      end
    })
  end

  vim.keymap.set("n", "<leader>sn", function()
    next_song()
  end, { silent = true })

  vim.keymap.set("n", "<leader>sp", function()
    prev_song()
  end, { silent = true })

  vim.keymap.set("n", "<leader>st", toggle_playback, { silent = true })
  local timer = vim.loop.new_timer()
  timer:start(1000, M.opts.status.update_interval, vim.schedule_wrap(force_update))
end

function M.status:on_event(data)
  if data then
    M._status_line = data[1]
  end
end

function M.status:listen()
  return M._status_line
end

return M
