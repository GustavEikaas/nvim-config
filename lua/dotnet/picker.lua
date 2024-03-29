local M = {}

M.picker = function(bufnr, options, on_select_cb, title)
  if (#options == 0) then
    error("No options provided, minimum 1 is required")
  end

  -- Auto pick if only one option present
  if (#options == 1) then
    on_select_cb(options[1])
    return
  end

  local picker = require('telescope.pickers').new(bufnr, {
    prompt_title = title,
    finder = require('telescope.finders').new_table {
      results = options,
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
