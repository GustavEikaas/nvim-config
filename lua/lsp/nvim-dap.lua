local function open_repl_only()
  local dapui = require "dapui"
  dapui.close()
  dapui.open { layout = 1 }
end
local function open_full_dap()
  local dapui = require "dapui"
  dapui.close()
  dapui.open()
end

return {
  "mfussenegger/nvim-dap",
  enabled = true,
  config = function()
    local dap = require "dap"
    dap.set_log_level "TRACE"
    local dapui = require "dapui"
    -- require("easy-dotnet.netcoredbg").register_dap_variables_viewer()

    vim.keymap.set("n", "<F5>", function()
      open_repl_only()
      dap.continue()
    end, {})

    vim.keymap.set("n", "q", function()
      dap.close()
    end, {})

    dap.listeners.after.event_stopped["dap_ui"] = function()
      open_full_dap()
    end

    dap.listeners.on_session["dap_ui"] = function(_, new)
      if new == nil then
        dapui.close()
      else
        open_repl_only()
      end
    end

    vim.keymap.set("n", "<F10>", dap.step_over, {})
    vim.keymap.set("n", "<leader>dO", dap.step_over, {})
    vim.keymap.set("n", "<leader>dC", dap.run_to_cursor, {})
    vim.keymap.set("n", "<leader>dr", dap.repl.toggle, {})
    vim.keymap.set("n", "<leader>dj", dap.down, {})
    vim.keymap.set("n", "<leader>dk", dap.up, {})
    vim.keymap.set("n", "<F11>", dap.step_into, {})
    vim.keymap.set("n", "<F12>", dap.step_out, {})
    vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, {})
    vim.keymap.set("n", "<F2>", require("dap.ui.widgets").hover, {})

    require("dap-config.lua").register_lua_dap()

    vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "", linehl = "DapBreakpoint", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "󰳟", texthl = "", linehl = "DapStopped", numhl = "" })
  end,
  dependencies = {
    { "jbyuki/one-small-step-for-vimkind" },
    {
      "nvim-neotest/nvim-nio",
    },
    {
      "rcarriga/nvim-dap-ui",
      config = function()
        require("dapui").setup {
          icons = { expanded = "", collapsed = "", current_frame = "" },
          mappings = {
            expand = { "<CR>" },
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
                {
                  id = "repl",
                  size = 1,
                },
                -- {
                --   id = "easy-dotnet_cpu",
                --   size = 0.5,
                -- },
                -- {
                --   id = "netcoredbg_cpu",
                --   size = 0.5,
                -- },
              },
              size = 10,
              position = "bottom",
            },
            {
              elements = { { id = "scopes", size = 1 } },
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
            enabled = vim.fn.exists "+winbar" == 1,
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
        }
      end,
    },
  },
}
