return {
  "norcalli/nvim-colorizer.lua",
  event = "BufRead",
  config = function()
    require("colorizer").setup()
  end
}
