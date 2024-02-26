return {
  "ggandor/leap.nvim",
  event = "LspAttach",
  config = function()
    require("leap").setup {}
    require("leap").create_default_mappings()
  end,
  lazy = false,
}
