local md = {}

md.setup = function()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
      vim.keymap.set("n", "<leader>pmd", function()
        vim.cmd("MarkdownPreviewToggle")
      end, { silent = true })
    end,
  })

  vim.api.nvim_create_user_command('MD', function()
    vim.cmd("MarkdownPreviewToggle")
  end, {})
end

return md
