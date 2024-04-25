return {
  dir = "C:\\Users\\Gustav\\repo\\gh-notify.nvim",
  config = function()
    local gh = require("gh-notify")
    gh.setup({
      polling = true
    })
  end
}
