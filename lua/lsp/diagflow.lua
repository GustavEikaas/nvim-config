return {
  "dgagn/diagflow.nvim",
  enabled = true,
  config = function()
    require('diagflow').setup({
      scope = 'line',
    })
  end,
  event = "LspAttach"
}
