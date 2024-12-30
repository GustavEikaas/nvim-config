return {
  "gregorias/coerce.nvim",
  dependencies = {"gregorias/coop.nvim"},
  config = function()
    require("coerce").setup()
  end,
}
