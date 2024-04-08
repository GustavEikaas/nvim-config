---
---@param co thread
local function rebuild(co)
  local num = 0;
  local spinner_frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }

  local notification = vim.notify(spinner_frames[1] .. " Building", "info", {
    title = "Dotnet",
    icon = spinner_frames[1],
    timeout = false,
    hide_from_history = false
  })

  vim.fn.jobstart("dotnet build .", {
    on_stdout = function(a)
      num = num + 1
      local new_spinner = (num) % #spinner_frames
      notification = vim.notify(spinner_frames[new_spinner] .. " Building", "info",
        { icon = spinner_frames[new_spinner], replace = notification, hide_from_history = false })
    end,
    on_exit = function(_, return_code)
      if return_code == 0 then
        vim.notify("Built successfully", "info", { replace = notification, timeout = 1000 })
      else
        vim.notify("", "info", { replace = notification, timeout = 1 })
        vim.notify("Build failed with exit code " .. return_code, "error", { timeout = 1000 })
        error("Build failed")
      end

      coroutine.resume(co)
    end,
  })
  coroutine.yield()
end

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
      args = { "--interpreter=vscode" },
    }

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
        local shouldRebuild = vim.fn.input("Do you want to rebuild? Y/N:  ")
        if shouldRebuild == "Y" then
          local co = coroutine.running()
          rebuild(co)
        end

        return dll.dll_path
      end,
    } }

    local function on_dap_exit()
      vim.cmd("cd " .. cwd)
    end

    dap.listeners.before.event_terminated["easy-dotnet"] = on_dap_exit
    dap.listeners.before.event_exited["easy-dotnet"] = on_dap_exit
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
        require("nvim-dap-virtual-text").setup({
          enabled = true,                     -- enable this plugin (the default)
          enabled_commands = true,            -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
          highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
          highlight_new_as_changed = false,   -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
          show_stop_reason = true,            -- show stop reason when stopped for exceptions
          commented = false,                  -- prefix virtual text with comment string
          only_first_definition = true,       -- only show virtual text at first definition (if there are multiple)
          all_references = false,             -- show virtual text on all all references of the variable (not only definitions)
          clear_on_continue = false,          -- clear virtual text on "continue" (might cause flickering when stepping)
          --- A callback that determines how a variable is displayed or whether it should be omitted
          --- @param variable Variable https://microsoft.github.io/debug-adapter-protocol/specification#Types_Variable
          --- @param buf number
          --- @param stackframe dap.StackFrame https://microsoft.github.io/debug-adapter-protocol/specification#Types_StackFrame
          --- @param node userdata tree-sitter node identified as variable definition of reference (see `:h tsnode`)
          --- @param options nvim_dap_virtual_text_options Current options for nvim-dap-virtual-text
          --- @return string|nil A text how the virtual text should be displayed or nil, if this variable shouldn't be displayed
          display_callback = function(variable, buf, stackframe, node, options)
            require("general.debug").write_to_log("Var::")
            require("general.debug").write_to_log(variable)
            if options.virt_text_pos == 'inline' then
              return ' = ' .. variable.value
            else
              return variable.name .. ' = ' .. variable.value
            end
          end,
          -- position of virtual text, see `:h nvim_buf_set_extmark()`, default tries to inline the virtual text. Use 'eol' to set to end of line
          virt_text_pos = 'eol', --vim.fn.has 'nvim-0.10' == 1 and 'inline' or 'eol',

          -- experimental features:
          all_frames = false,     -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
          virt_lines = false,     -- show virtual lines instead of virtual text (will flicker!)
          virt_text_win_col = nil -- position the virtual text at a fixed window column (starting from the first text column) ,
          -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
        })
      end

    }
  }
}
