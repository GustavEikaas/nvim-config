return {
  "norcalli/nvim-colorizer.lua",
  enabled = not vim.g.is_perf,
  event = "BufRead",
  config = function()
    require("colorizer").setup({ "*" }, {
      names = false,        -- "Name" codes like Blue
      mode  = 'background', -- Set the display mode.
    })
  end
}
