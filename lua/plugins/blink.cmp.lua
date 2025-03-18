local disabled_filetypes = { "DressingInput" }
return {
  "saghen/blink.cmp",
  version = "*",
  config = function()
    require("blink.cmp").setup {
      enabled = function()
        return not vim.list_contains(disabled_filetypes, vim.bo.filetype)
      end,
      fuzzy = {
        implementation = "prefer_rust_with_warning",
        sorts = {
          function(a, b)
            return a.kind > b.kind
          end,
          "score",
          "sort_text",
        },
      },
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
