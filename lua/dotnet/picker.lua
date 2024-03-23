local M = {}

M.picker = function(bufnr, projects, on_select_cb)
  if (#projects == 0) then
    error("No projects provided, minimum 1 is required")
  end

  -- Auto pick if only one option present
  if (#projects == 1) then
    on_select_cb(projects[1])
    return
  end

  local picker = require('telescope.pickers').new(bufnr, {
    prompt_title = "Run project",
    finder = require('telescope.finders').new_table {
      results = projects,
      entry_maker = function(entry)
        return {
          display = entry.display,
          value = entry,
          ordinal = entry.display,
        }
      end,
    },
    sorter = require('telescope.config').values.generic_sorter({}),
    attach_mappings = function(_, map)
      map('i', '<CR>', function(prompt_bufnr)
        local selection = require('telescope.actions.state').get_selected_entry()
        require('telescope.actions').close(prompt_bufnr)
        on_select_cb(selection.value)
      end)
      return true
    end,
  })
  picker:find()
end

return M
