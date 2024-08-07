return {
  "GustavEikaas/easy-dotnet.nvim",
  -- dir = "C:\\Users\\Gustav\\repo\\easy-dotnet.nvim",
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
        require("toggleterm").exec(command, nil, nil, nil, "float")
      end,
    })

    vim.api.nvim_create_user_command('Secrets', function()
      dotnet.secrets()
    end, {})

    -- Temp
    vim.keymap.set("n", "<leader>r", dotnet.run_project)
    -- collides with breakpoints
    -- vim.keymap.set("n", "<leader>b", dotnet.build_solution)
    vim.keymap.set("n", "<leader>t", dotnet.test_solution)

    vim.keymap.set("n", "<C-p>", function()
      dotnet.run_project()
    end)
  end
}
