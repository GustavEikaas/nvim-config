return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  lazy = false,
  ---@module "neo-tree"
  ---@type neotree.Config?
  config = function()
    require("neo-tree").setup {
      close_if_last_window = true,
      enable_git_status = true,
      enable_diagnostics = true,
      filesystem = {
        filtered_items = {
          visible = false,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_hidden = false,
        },
      },
      window = {
        position = "right",
        width = 40,
        mapping_options = {
          noremap = true,
          nowait = true,
        },
        mappings = {
          ["o"] = {
            function(state)
              local node = state.tree:get_node()
              local path = node.path
              local stat = vim.loop.fs_stat(path)
              if stat then
                if stat.type == "directory" then
                  require("neo-tree.sources.filesystem").toggle_directory(state, node)
                else
                  require("neo-tree.utils").open_file(state, path)
                end
              end
            end,
            desc = "Open file or toggle directory",
          },
          ["<esc>"] = "cancel", -- close preview or floating neo-tree window
          ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
          -- Read `# Preview Mode` for more information
          ["l"] = "focus_preview",
          ["S"] = "open_split",
          ["s"] = "open_vsplit",
          -- ["S"] = "split_with_window_picker",
          -- ["s"] = "vsplit_with_window_picker",
          ["t"] = "open_tabnew",
          -- ["<cr>"] = "open_drop",
          -- ["t"] = "open_tab_drop",
          ["w"] = "open_with_window_picker",
          --["P"] = "toggle_preview", -- enter preview mode, which shows the current node without focusing
          ["C"] = "close_node",
          -- ['C'] = 'close_all_subnodes',
          ["z"] = "close_all_nodes",
          --["Z"] = "expand_all_nodes",
          ["a"] = {
            "add",
            -- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
            -- some commands may take optional config options, see `:h neo-tree-mappings` for details
            config = {
              show_path = "none", -- "none", "relative", "absolute"
            },
          },
          ["A"] = "add_directory", -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
          ["d"] = "delete",
          ["r"] = "rename",
          ["b"] = "rename_basename",
          ["c"] = "copy_to_clipboard",
          ["x"] = "cut_to_clipboard",
          ["p"] = "paste_from_clipboard",
          ["y"] = function(state)
            local node = state.tree:get_node()
            local filename = vim.fn.fnamemodify(node.path, ":t")
            vim.fn.setreg("+", filename)
            print("Copied filename: " .. filename)
          end,
          ["gy"] = function(state)
            local node = state.tree:get_node()
            local path = vim.fs.normalize(vim.fn.fnamemodify(node.path, ":."))
            local relative_path = "./" .. path
            vim.fn.setreg("+", relative_path)
            print("Copied relative path: " .. relative_path)
          end,
          ["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
          ["q"] = "close_window",
          ["R"] = "refresh",
          ["?"] = "show_help",
          ["<"] = "prev_source",
          [">"] = "next_source",
          ["i"] = "show_file_details",
          -- ["i"] = {
          --   "show_file_details",
          --   -- format strings of the timestamps shown for date created and last modified (see `:h os.date()`)
          --   -- both options accept a string or a function that takes in the date in seconds and returns a string to display
          --   -- config = {
          --   --   created_format = "%Y-%m-%d %I:%M %p",
          --   --   modified_format = "relative", -- equivalent to the line below
          --   --   modified_format = function(seconds) return require('neo-tree.utils').relative_date(seconds) end
          --   -- }
          -- },
        },
      },
    }
    vim.keymap.set("n", "<leader>e", function()
      vim.cmd "Neotree reveal"
    end, { nowait = true })

    vim.keymap.set("n", "<C-n>", function()
      vim.cmd "Neotree reveal toggle"
    end, { nowait = true })
  end,
}
