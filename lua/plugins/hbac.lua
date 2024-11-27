return {
  -- Prevents the bufferline from junking up
  "axkirillov/hbac.nvim",
  config = function()
    require("buf-cycle").setup()
  end
}
