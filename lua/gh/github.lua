local M = {
  opts = {
    status = {
      update_interval = 10000,
    }
  },
  status = {},
  _status_line = ""
}

local function executeCommand(cmd)
  local handle = io.popen(cmd)
  if handle == nil then
    error("Failed to exec " .. cmd)
  end
  local value = handle:read("*a")
  handle:close()
  return value
end

function M.status:start()
  local currBranch = nil
  local function force_update()
    local branch = executeCommand("git rev-parse --abbrev-ref HEAD")
    if branch == currBranch then
      return
    end
    currBranch = branch
    local cmd = "gh pr view --json mergeable,state,mergeStateStatus,title"
    vim.fn.jobstart(cmd, { on_stdout = self.on_event, stdout_buffered = true })
  end

  local timer = vim.loop.new_timer()
  timer:start(1000, M.opts.status.update_interval, vim.schedule_wrap(force_update))
end

function M.status:on_event(data)
  if data and #data[1] > 0 then
    local pr = vim.fn.json_decode(data[1])
    local status = pr.mergeable == "MERGEABLE" and "✔" or "🔴"
    M._status_line = " " .. pr.title .. status
  else
    M._status_line = ""
  end
end

function M.status:listen()
  return M._status_line
end

return M
