return {
  "norcalli/nvim-colorizer.lua",
  event = "BufRead",
  config = function()
    require("colorizer").setup({ "*" }, {
      names = false,        -- "Name" codes like Blue
      mode  = 'background', -- Set the display mode.
    })
  end
}
