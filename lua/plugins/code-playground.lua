return {
  "GustavEikaas/code-playground.nvim",
  enabled = not vim.g.is_perf,
  -- dir = "C:\\Users\\Gustav\\repo\\code-playground.nvim",
  config = function()
    local playground = require("code-playground")
    playground.setup()
  end
}
