return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  build = "cd app | yarn install",
  init = function()
    vim.g.mkdp_theme = 'dark'
    vim.g.mkdp_filetypes = { "markdown", "octo" }
  end,
  ft = { "markdown", "octo" },
}