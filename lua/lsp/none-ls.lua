return {
  "nvimtools/none-ls.nvim",
  event = "LspAttach",
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      null_ls.builtins.formatting.stylua,
      null_ls.builtins.formatting.prettier,
    })
    null_ls.register { name = "c#", filtetypes = { "cs" }, sources = { null_ls.builtins.formatting.csharpier } }
    vim.keymap.set("n", "<leader>fm", vim.lsp.buf.format, {})
  end
}
