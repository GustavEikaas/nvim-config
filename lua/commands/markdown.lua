local md = {}

md.setup = function()
  vim.api.nvim_create_user_command('MD', function()
    vim.cmd("MarkdownPreviewToggle")
  end, {})
end

return md
