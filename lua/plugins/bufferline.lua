return {
  "akinsho/bufferline.nvim",
  config = function()
    require("bufferline").setup({})
    vim.keymap.set("n", "<tab>", ":bnext<CR>", { noremap = true, silent = true })
    vim.keymap.set("n", "<S-tab>", ":bprev<CR>", { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>x", ":bdelete|bprev<CR>", { noremap = true, silent = true })
  end
}
