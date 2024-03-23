local M = {}
local extensions = require("extensions")

local function on_secret_selected(item)
  local home_dir = vim.fn.expand('~')
  local secret_path = home_dir .. '\\AppData\\Roaming\\Microsoft\\UserSecrets\\' .. item.secrets .. "\\secrets.json"
  vim.notify(secret_path)
  vim.cmd("edit " .. vim.fn.fnameescape(secret_path))
end

local function on_select(selectedItem)
  local term = require("nvterm.terminal")
  term.send("dotnet run --project " .. selectedItem.path .. "\r\n", "float")
end

local dotnet_picker = function(bufnr, projects, on_select_cb)
  -- No runnable projects found
  if (#projects == 0) then
    -- TODO: handle errors
    vim.notify("No runnable web projects found")
    return
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

local function dotnetRunPicker()
  local sln_parser = require("dotnet.sln-parse")
  local solutionFilePath = sln_parser.find_solution_file()
  if solutionFilePath == nil then
    vim.notify("No .sln file found")
    return
  end
  local projects = extensions.filter(sln_parser.get_projects_from_sln(solutionFilePath), function(i)
    return i.runnable
  end)

  dotnet_picker(nil, projects, on_select)
end

local function editSecrets()
  local sln_parser = require("dotnet.sln-parse")
  local solutionFilePath = sln_parser.find_solution_file()
  if solutionFilePath == nil then
    vim.notify("No .sln file found")
  end

  local projectsWithSecrets = extensions.filter(sln_parser.get_projects_from_sln(solutionFilePath), function(i)
    return i.secrets ~= false and i.path ~= nil and i.runnable == true
  end)


  extensions.foreach(projectsWithSecrets, function(i)
    require("dotnet.debug").write_to_log(require("dotnet.debug").table_to_string(i))
  end)

  dotnet_picker(nil, projectsWithSecrets, on_secret_selected)
end

M.setup = function()
  vim.keymap.set("n", "<C-p>", function()
    dotnetRunPicker()
  end)


  vim.api.nvim_create_user_command('Secrets', function()
    editSecrets()
  end, {})
end



return M
