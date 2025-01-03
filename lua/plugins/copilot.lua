return {
  "github/copilot.vim",
  enabled = not vim.g.is_perf,
  config = function()
    vim.keymap.set('n', '<C-a>', 'copilot#Accept("\\<CR>")', {
      expr = true,
      replace_keycodes = false
    })

    vim.keymap.set('i', '<C-a>', 'copilot#Accept("\\<CR>")', {
      expr = true,
      replace_keycodes = false
    })
    vim.g.copilot_no_tab_map = true
  end
}