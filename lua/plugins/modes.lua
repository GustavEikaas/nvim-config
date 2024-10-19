return {
  'mvllow/modes.nvim',
  enabled = not vim.g.is_perf,
  tag = 'v0.2.0',
  config = function()
    require('modes').setup()
  end
}
