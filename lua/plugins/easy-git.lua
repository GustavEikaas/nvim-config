return {
  "GustavEikaas/easy-git.nvim",
  -- dir = "C:\\Users\\Gustav\\repo\\easy-git",
  enabled = false,
  dependencies = { 'nvim-telescope/telescope.nvim', },
  config = function()
    local git = require("easy-git")
    git.setup()

    vim.api.nvim_create_user_command('GGRF', git.restore_current_file, {})
  end
}
