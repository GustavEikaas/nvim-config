return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    enabled = not vim.g.is_perf,
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      }
    },
  },
  {
    -- optional `vim.uv` typings
    "Bilal2453/luvit-meta",
    enabled = not vim.g.is_perf,
    lazy = true
  },
}
