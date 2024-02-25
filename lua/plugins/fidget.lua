return {
  "j-hui/fidget.nvim",
  opts = {
  },
  config = function()
    require("fidget").setup()
    vim.notify = require("fidget").notify
  end
}
