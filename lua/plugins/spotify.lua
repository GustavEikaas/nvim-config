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

return {
  'KadoBOT/nvim-spotify',
  requires = 'nvim-telescope/telescope.nvim',
  config = function()
    local spotify = require 'nvim-spotify'

    spotify.setup {
      -- default opts
      status = {
        update_interval = 10000, -- the interval (ms) to check for what's currently playing
        format = '%s %t by %a'   -- spotify-tui --format argument
      }
    }
    vim.keymap.set("n", "<leader>sn", next_song, { silent = true })       -- Skip the current track
    vim.keymap.set("n", "<leader>sp", prev_song, { silent = true })       -- Skip the current track
    vim.keymap.set("n", "<leader>st", toggle_playback, { silent = true }) -- Skip the current track
  end,
}
