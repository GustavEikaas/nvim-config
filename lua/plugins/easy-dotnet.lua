return {
  -- "GustavEikaas/easy-dotnet.nvim",
  dir = "C:\\Users\\Gustav\\repo\\easy-dotnet.nvim",
  dependencies = { "nvim-lua/plenary.nvim", 'nvim-telescope/telescope.nvim', },
  config = function()
    local dotnet = require("easy-dotnet")
    dotnet.setup({
      terminal = function(path, action)
        local commands = {
          run = function()
            return "dotnet run --project " .. path
          end,
          test = function()
            return "dotnet test " .. path
          end,
          restore = function()
            return "dotnet restore " .. path
          end,
          build = function()
            return "dotnet build " .. path
          end
        }
        local command = commands[action]() .. "\r"
        local term = require("nvterm.terminal")
        term.send(command, "float")
      end,
    })

    vim.api.nvim_create_user_command('Secrets', function()
      dotnet.secrets()
    end, {})

    vim.keymap.set("n", "<C-p>", function()
      dotnet.run_project()
    end)
  end
}
