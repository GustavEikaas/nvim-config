return {
  'echasnovski/mini.comment',
  event = "BufEnter",
  version = false,
  config = function()
    require("mini.comment").setup({
      mappings = {
        comment = '<leader>/',
        comment_line = '<leader>/',
        comment_visual = '<leader>/',
      },
    })
  end
}
