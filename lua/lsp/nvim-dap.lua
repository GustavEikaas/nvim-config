return {
  "mfussenegger/nvim-dap",
  enabled = true,
  config = function()
    local dap = require("dap")
    dap.set_log_level("TRACE")
    local dapui = require("dapui")

    dap.listeners.after.event_initialized["dapui_config"] = function()
      require('nvim-tree.api').tree.close()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    vim.keymap.set("n", "<F5>", dap.continue, {})
    vim.keymap.set("n", "q", dap.close, {})
    vim.keymap.set("n", "<F10>", dap.step_over, {})
    vim.keymap.set("n", "<F11>", dap.step_into, {})
    vim.keymap.set("n", "<F12>", dap.step_out, {})
    vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, {})
    vim.keymap.set("n", "<F2>", require("dap.ui.widgets").hover, {})
    vim.keymap.set("n", "<F3>", dap.run_to_cursor, {})

    vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = '', linehl = 'DapBreakpoint', numhl = '' })
    vim.fn.sign_define('DapStopped', { text = '󰳟', texthl = '', linehl = "DapStopped", numhl = '' })

    dap.adapters.coreclr = {
      type = "executable",
      command = "netcoredbg",
      args = { "--interpreter=vscode" },
    }

    -- https://github.com/jbyuki/one-small-step-for-vimkind
    dap.configurations.lua = { {
      type = 'nlua',
      request = 'attach',
      name = "Attach to running Neovim instance",
    } }

    dap.adapters.nlua = function(callback, config)
      callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
    end

    local cwd = vim.fn.getcwd()

    dap.configurations.cs = { {
      type = "coreclr",
      name = "launch - netcoredbg",
      request = "launch",
      env = {
        ["ASPNETCORE_ENVIRONMENT"] = "DEVELOPMENT"
      },
      program = function()
        local dll = require("easy-dotnet").get_debug_dll()
        vim.cmd("cd " .. dll.project_path)
        return dll.dll_path
      end,
    } }


    dap.listeners.before.event_terminated["easy-dotnet"] = function()
      -- Reset cwd when debugging stops
      vim.cmd("cd " .. cwd)
    end
    dap.listeners.before.event_exited["easy-dotnet"] = function()
      -- Reset cwd when debugging stops
      vim.cmd("cd " .. cwd)
    end
  end,
  dependencies = {
    { "jbyuki/one-small-step-for-vimkind" },
    {
      "nvim-neotest/nvim-nio",
    },
    {
      "rcarriga/nvim-dap-ui",
      config = function()
        require("dapui").setup({
          icons = { expanded = "", collapsed = "", current_frame = "" },
          mappings = {
            expand = { "<CR>", "<2-LeftMouse>" },
            open = "o",
            remove = "d",
            edit = "e",
            repl = "r",
            toggle = "t",
          },
          element_mappings = {},
          expand_lines = true,
          force_buffers = true,
          layouts = {
            {
              elements = {
                { id = "scopes", size = 0.33 },
                {
                  id = "repl",
                  size = 0.66,
                },
              },

              size = 10,
              position = "bottom",
            },
            {
              elements = {
                "breakpoints",
                -- "console",
                "stacks",
                "watches",
              },
              size = 45,
              position = "right",
            },
          },
          floating = {
            max_height = nil,
            max_width = nil,
            border = "single",
            mappings = {
              ["close"] = { "q", "<Esc>" },
            },
          },
          controls = {
            enabled = vim.fn.exists("+winbar") == 1,
            element = "repl",
            icons = {
              pause = "",
              play = "",
              step_into = "",
              step_over = "",
              step_out = "",
              step_back = "",
              run_last = "",
              terminate = "",
              disconnect = "",
            },
          },
          render = {
            max_type_length = nil, -- Can be integer or nil.
            max_value_lines = 100, -- Can be integer or nil.
            indent = 1,
          },
        })
      end
    },
    {
      "theHamsta/nvim-dap-virtual-text",
      config = function()
        require("nvim-dap-virtual-text").setup()
      end

    }
  }
}
