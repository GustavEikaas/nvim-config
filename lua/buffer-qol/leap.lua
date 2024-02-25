return {
  "ggandor/leap.nvim",
  event = "BufEnter",
  config = function()
    require("leap").setup {}
    require("leap").create_default_mappings()
  end,
  lazy = false,
}
