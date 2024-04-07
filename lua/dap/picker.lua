local M = {}

-- Function to pick a single DLL file from a specific subfolder
M.pick_dll_file = function()
  local builtin = require("telescope.builtin")
  local actions = require("telescope.actions")
  local rootPath = vim.fn.getcwd()
  local folder_path = rootPath .. "/bin/Debug/net8.0"

  local results = builtin.find_files({
    prompt_title = "Select DLL File",
    cwd = folder_path,
    attach_mappings = function(_, map)
      map('i', '<CR>', function(prompt_bufnr)
        local entry = actions.get_selected_entry(prompt_bufnr)
        actions.close(prompt_bufnr)
        print(entry.path)
      end)
      return true
    end
  })

  return results
end
return M
