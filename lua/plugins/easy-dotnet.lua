return {
  "GustavEikaas/easy-dotnet.nvim",
  -- dir = "C:\\Users\\Gustav\\repo\\easy-dotnet.nvim",
  dependencies = { "nvim-lua/plenary.nvim", 'nvim-telescope/telescope.nvim', },
  config = function()
    require "easy-dotnet".setup({
      run_project = {
        on_select = function(selectedItem)
          vim.notify(selectedItem.path)
          local term = require("nvterm.terminal")
          term.send("dotnet run --project " .. selectedItem.path .. "\r\n", "float")
        end
      }
    })
  end
}
