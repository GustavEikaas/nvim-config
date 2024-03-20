local function print_song()
  local handle = io.popen("spt playback --status")
  if handle == nil then
    return
  end
  local value = handle:read("*a")
  handle:close()
  vim.notify(value)
end

local function toggle_playback()
  os.execute("spt playback --toggle")
  print_song()
end

local function prev_song()
  os.execute("spt playback --previous")
  print_song()
end

local function next_song()
  os.execute("spt playback --next")
  print_song()
end


vim.keymap.set("n", "<leader>sn", next_song, { silent = true })       -- Skip the current track
vim.keymap.set("n", "<leader>sp", prev_song, { silent = true })       -- Skip the current track
vim.keymap.set("n", "<leader>st", toggle_playback, { silent = true }) -- Skip the current track

local M = {
  opts = {
    status = {
      update_interval = 10000,
      format = '%s %t by %a'
    }
  },
  status = {},
  _status_line = ""
}


function M.status:start()
  local timer = vim.loop.new_timer()
  timer:start(1000, M.opts.status.update_interval, vim.schedule_wrap(function()
    local cmd = "spt playback --status --format '" .. M.opts.status.format .. "'"
    vim.fn.jobstart(cmd, { on_stdout = self.on_event, stdout_buffered = true })
  end))
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
