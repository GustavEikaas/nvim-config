return {
  "saghen/blink.cmp",
  version = "*",
  config = function()
    require("blink.cmp").setup {
      fuzzy = { implementation = "prefer_rust_with_warning" },
      keymap = {
        ["<CR>"] = { "select_and_accept", "fallback" },
        ["<Tab>"] = { "select_next" },
        ["<S-Tab>"] = { "select_prev" },
        ["<C-d>"] = { "scroll_documentation_down" },
        ["<C-u>"] = { "scroll_documentation_up" },
      },
      sources = {
        default = { "lsp", "easy-dotnet", "path" },
        providers = {
          ["easy-dotnet"] = {
            name = "easy-dotnet",
            enabled = true,
            module = "easy-dotnet.completion.blink",
            score_offset = 10000,
            async = true,
          },
        },
      },
    }
  end,
}
