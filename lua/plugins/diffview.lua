return {
  "sindrets/diffview.nvim",
  event = "VeryLazy",
   config = function ()
   require("diffview").setup()
   vim.api.nvim_create_user_command('PrReview', ':DiffviewOpen origin/main...HEAD<CR>', {})
   vim.api.nvim_create_user_command('PrClose', ':DiffviewClose<CR>', {})
   end,
}
