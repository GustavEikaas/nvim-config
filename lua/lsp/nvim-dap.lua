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

    vim.fn.sign_define('DapBreakpoint', { text = '🛑', texthl = '', linehl = 'DapBreakpoint', numhl = '' })
    vim.fn.sign_define('DapStopped', { text = '󰳟', texthl = '', linehl = "DapStopped", numhl = '' })

    dap.adapters.coreclr = {
      type = "executable",
      command = "netcoredbg",
      args = { "--interpreter=vscode" }
    }

    local cwd = vim.fn.getcwd()
    local dotnetProcessId = nil
    dap.configurations.cs = { {
      type = "coreclr",
      name = "launch - netcoredbg",
      request = "attach",
      processId = function()
        return dotnetProcessId
      end,
      preLaunchTask = function()
        cwd = vim.fn.getcwd()
        -- Change cwd to project cwd
        require("easy-dotnet").get_debug_dll()


        -- local co = coroutine.running()
        -- vim.notify("Starting dotnet process")
        --

        local handle = io.popen(
          "powershell.exe -Command \"$processId = (Start-Process -FilePath 'dotnet' -ArgumentList 'run' -PassThru).Id; Write-Output $processId\"")
        if handle == nil then
          error("Failed to start webapi")
        end
        local result = handle:read("*a")
        handle:close()
        dotnetProcessId = tonumber(result)
      end
    } }

    dap.listeners.before.event_terminated["easy-dotnet"] = function()
      -- Reset cwd when debugging stops
      vim.cmd("cd " .. cwd)
      os.execute("kill " .. dotnetProcessId)
    end
    dap.listeners.before.event_exited["easy-dotnet"] = function()
      -- Reset cwd when debugging stops
      vim.cmd("cd " .. cwd)
      os.execute("kill " .. dotnetProcessId)
    end
  end,
  dependencies = {
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
