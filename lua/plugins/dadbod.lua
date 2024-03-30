return {
  'kristijanhusak/vim-dadbod-ui',
  dependencies = {
    { 'tpope/vim-dadbod',                     lazy = true },
    { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
  },
  cmd = {
    'DBUI',
    'DBUIToggle',
    'DBUIAddConnection',
    'DBUIFindBuffer',
  },
  init = function()
    -- Your DBUI configuration
    vim.g.db_ui_winwidth = 40
    vim.g.db_ui_use_nvim_notify = 1
    vim.g.db_ui_icons = {
      expanded = '',
      collapsed = '',
      saved_query = '',
      new_query = '󰎔',
      tables = '󰓫',
      buffers = '',
      connection_ok = '✓',
      connection_error = '✕',
    }

    vim.g.db_ui_use_nerd_fonts = 1
  end,
}
