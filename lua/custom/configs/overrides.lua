local M = {}

M.treesitter = {
  ensure_installed = {
    "vim",
    "lua",
    "html",
    "css",
    "javascript",
    "typescript",
    "tsx",
    "c",
    "markdown",
    "markdown_inline",
  },
  indent = {
    enable = true,
    -- disable = {
    --   "python"
    -- },
  },
}

M.mason = {
  ensure_installed = {
    -- lua stuff
    "lua-language-server",
    "luaformatter",
    "luacheck",
    "stylua",

    -- requires go installed
    "gopls",

    -- java
    "java-language-server",

    -- C#
    "omnisharp",
    "csharpier",
    -- webdev
    "prettierd",
    "html-lsp",
    "typescript-language-server",
    "deno",
    "prettier",
    "htmlbeautifier",
    "json-lsp",
    "jq-lsp",
    "htmlhint",
    "htmx-lsp",
    "astro-language-server",
    "cssmodules-language-server",
    "css-lsp",
    "svelte-language-server",
    "tailwindcss-language-server",

    -- python
    "python-lsp-server",

    -- sql
    "sql-formatter",

    -- scripting
    "azure-pipelines-language-server",
    "bash-language-server",
    "docker-compose-lanuage-service",
    "dockerfile-language-server",
    "yaml-language-server",
    "powershell-editor-services",
    "vim-language-server",

    -- rust
    "rust-analyzer",

    -- c/cpp stuff
    "clangd",
    "clang-format",
  },
}

-- git support in nvimtree
M.nvimtree = {
  git = {
    enable = true,
  },

  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
}

return M
