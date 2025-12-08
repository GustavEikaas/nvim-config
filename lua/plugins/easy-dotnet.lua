local function add_dotnet_mappings()
  local dotnet = require "easy-dotnet"

  vim.api.nvim_create_user_command("Secrets", function()
    dotnet.secrets()
  end, {})

  vim.keymap.set("n", "<A-t>", function()
    vim.cmd "Dotnet testrunner"
  end, { nowait = true })

  vim.keymap.set("n", "<C-p>", function()
    vim.cmd("Dotnet debug profile default")
  end, { nowait = true })

  vim.keymap.set("n", "<C-b>", function()
    dotnet.build_default_quickfix()
  end, { nowait = true })
end

return {
  "GustavEikaas/easy-dotnet.nvim",
  dir = "/home/gus/repo/easy-dotnet.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
  config = function()
    local dotnet = require "easy-dotnet"
    dotnet.setup {
      lsp = {
        enabled = true,
      },
      test_runner = {
        enable_buffer_test_execution = true,
        viewmode = "float",
      },
      notifications = {
        handler = false,
      },
      debugger = {
        bin_path = "netcoredbg",
        apply_value_converters = true,
      },
      auto_bootstrap_namespace = {
        type = "file_scoped",
        enabled = true,
      },
      server = {
        use_visual_studio = false,
        ---@type nil | "Off" | "Critical" | "Error" | "Warning" | "Information" | "Verbose" | "All"
        log_level = "Verbose",
      },
      terminal = function(path, action, args, ctx)
        local commands = {
          run = function()
            return string.format("%s %s", ctx.cmd, args)
          end,
          test = function()
            return string.format("%s %s", ctx.cmd, args)
          end,
          restore = function()
            return string.format("%s %s", ctx.cmd, args)
          end,
          build = function()
            return string.format("%s %s", ctx.cmd, args)
          end,
          watch = function()
            return string.format("dotnet watch --project %s %s", path, args)
          end,
        }

        local command = commands[action]() .. "\r"
        require("toggleterm").exec(command, nil, nil, nil, "float")
      end,
    }

    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        if dotnet.is_dotnet_project() then
          add_dotnet_mappings()
        end
      end,
    })
  end,
}
