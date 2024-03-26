return {
  "mfussenegger/nvim-dap",
  enabled = true,
  config = function()
    local dap = require("dap")
    dap.set_log_level("TRACE")
    local dapui = require("dapui")

    dap.listeners.after.event_initialized["dapui_config"] = function()
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
    vim.keymap.set("n", "<F2>", dapui.eval, {})

    dap.adapters.coreclr = {
      type = "executable",
      -- command = vim.fn.stdpath("data") .. "\\netcoredbg\\netcoredbg.exe",
      command = "netcoredbg",
      args = { "--interpreter=vscode" }
    }

    dap.configurations.cs = { {
      type = "coreclr",
      name = "launch - netcoredbg",
      request = "launch",
      program = function()
        local function get_recursive_dll_files(skip_count)
          local target_folder = "bin/Debug"
          local find_command = 'find . -path "*/' .. target_folder .. '/*.dll" -not -regex ".*\\/(ref|refint)/.*"'

          local files = {}
          local file_map = {}
          for line in io.popen(find_command):lines() do
            local clean_line = string.gsub(line, target_folder .. "/", "")
            local parts = {}
            local count = 0
            local filename = string.match(clean_line, "([^/]+)$")
            for part in string.gmatch(clean_line, "([^/]+)") do
              if not string.find(part, "^net[0-9\\.]+$") then
                count = count + 1
                if count <= skip_count or part == filename then
                  table.insert(parts, part)
                else
                  table.insert(parts, string.sub(part, 1, 1))
                end
              end
            end
            local display_name = table.concat(parts, "/")
            file_map[display_name] = line
            table.insert(files, display_name)
          end
          return files, file_map
        end

        local function get_file_sync()
          local co = coroutine.running()
          local selected_file = nil
          local files, file_map = get_recursive_dll_files(3)

          vim.ui.select(files, {}, function(short_filename)
            selected_file = file_map[short_filename]
            coroutine.resume(co)
          end)

          coroutine.yield()
          return selected_file
        end

        local file = get_file_sync()
        print(file)
        return file
      end
    } }
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
                { id = "breakpoints", size = 0.25 },
                {
                  id = "scopes",
                  size = 0.75,
                },
              },

              size = 10,
              position = "bottom",
            },
            {
              elements = {
                "repl",
                "console",
                "stacks",
                "watches",
              },
              size = 35,
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
