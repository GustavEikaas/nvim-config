local disabled_filetypes = { "DressingInput", "TelescopePrompt" }
return {
  "saghen/blink.cmp",
  version = "*",
  dependencies = { "moyiz/blink-emoji.nvim" },
  config = function()
    require("blink.cmp").setup {
      enabled = function()
        return not vim.list_contains(disabled_filetypes, vim.bo.filetype)
      end,
      fuzzy = {
        implementation = "prefer_rust_with_warning",
      },
      keymap = {
        ["<CR>"] = { "select_and_accept", "fallback" },
        ["<Tab>"] = { "select_next" },
        ["<S-Tab>"] = { "select_prev" },
        ["<C-d>"] = { "scroll_documentation_down" },
        ["<C-u>"] = { "scroll_documentation_up" },
      },
      sources = {
        default = { "lsp", "easy-dotnet", "path", "snippets", "buffer", "emoji" },
        providers = {
          lsp = {
            name = "lsp",
            enabled = true,
            module = "blink.cmp.sources.lsp",
            score_offset = 90,
          },
          ["easy-dotnet"] = {
            name = "easy-dotnet",
            enabled = true,
            module = "easy-dotnet.completion.blink",
            score_offset = 10000,
            async = true,
          },
          path = {
            name = "Path",
            module = "blink.cmp.sources.path",
            score_offset = 25,
            fallbacks = { "snippets", "buffer" },
            opts = {
              trailing_slash = false,
              label_trailing_slash = true,
              get_cwd = function(context)
                return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
              end,
              show_hidden_files_by_default = true,
            },
          },
          buffer = {
            name = "Buffer",
            enabled = true,
            max_items = 3,
            module = "blink.cmp.sources.buffer",
            min_keyword_length = 4,
            score_offset = 15,
          },
          emoji = {
            module = "blink-emoji",
            name = "Emoji",
            score_offset = 93,
            min_keyword_length = 2,
            opts = { insert = true },
          },
        },
      },
      completion = {
        menu = {
          border = "single",
        },
        documentation = {
          auto_show = true,
          window = {
            border = "single",
          },
        },
        ghost_text = {
          enabled = true,
        },
      },
    }
  end,
}
