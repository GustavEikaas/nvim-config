return {
  "ggandor/leap.nvim",
  config = function()
    require("leap").setup {}
    require("leap").create_default_mappings()
  end,
  lazy = false,
}
