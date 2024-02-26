return {
  "j-hui/fidget.nvim",
  event = "VeryLazy",
  opts = {
  },
  config = function()
    require("fidget").setup()
    vim.notify = require("fidget").notify
  end
}
