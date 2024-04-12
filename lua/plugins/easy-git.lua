return {
  "GustavEikaas/easy-git.nvim",
  -- dir = "C:\\Users\\Gustav\\repo\\easy-git",
  dependencies = { 'nvim-telescope/telescope.nvim', },
  config = function()
    local git = require("easy-git")
    git.setup()

    vim.api.nvim_create_user_command('B', git.pick_branch, {})
    vim.api.nvim_create_user_command('GGRF', git.restore_current_file, {})
    vim.api.nvim_create_user_command("GGRM", git.reset_to_main, {})
    vim.api.nvim_create_user_command("GGR", git.reset_branch, {})
  end
}
