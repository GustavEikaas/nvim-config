return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  config = function()
    local harpoon = require("harpoon")

    -- REQUIRED
    harpoon:setup()

    local conf = require("telescope.config").values
    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
          results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_buffer_number, map)
          map(
            "i",
            "<S-d>", -- your mapping here
            function()
              local state = require("telescope.actions.state")
              local selected_entry = state.get_selected_entry()
              harpoon:list():removeAt(selected_entry.index)
              toggle_telescope(harpoon:list())
            end
          )

          return true
        end
      }):find()
    end

    vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end,
      { desc = "Open harpoon window" })
    -- REQUIRED

    vim.keymap.set("n", "<leader>a", function()
      harpoon:list():append()
      vim.notify("File added")
    end)

    vim.keymap.set("n", "<leader>x", function()
      harpoon:list():remove()
      vim.notify("File removed")
    end)

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set("n", "<S-tab>", function() harpoon:list():prev() end)
    vim.keymap.set("n", "<tab>", function() harpoon:list():next() end)
  end,
  dependencies = { "nvim-lua/plenary.nvim" }
}
