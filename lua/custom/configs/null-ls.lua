local null_ls = require "null-ls"

local b = null_ls.builtins

local sources = {
  -- webdev
  b.formatting.prettier,
  -- c#
  b.formatting.csharpier,
  -- Lua
  b.formatting.stylua,
  -- cpp
  b.formatting.clang_format,
}

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

require("null-ls").setup {
  debug = true,
  sources = sources,
  on_attach = function(client, bufnr)
    if client.supports_method "textDocument/formatting" then
      vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format { async = false }
        end,
      })
    end
  end,
}

require("null-ls").register { name = "c#", filtetypes = { "cs" }, sources = { b.formatting.csharpier } }
