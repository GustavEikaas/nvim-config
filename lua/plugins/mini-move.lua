return {
  'echasnovski/mini.move',
  version = false,
  config = function()
    require("mini.move").setup({
      mappings = {
        down = '<A-j>',
        up = '<A-k>',
        line_down = '<A-j>',
        line_up = '<A-k>',
      },
    })
  end
}
