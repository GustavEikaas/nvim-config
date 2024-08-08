local function parseXmlLine(xml)
  local results = {}
  local pattern = '<UnitTestResult[^>]*testName="([^"]*)"[^>]*outcome="([^"]*)"[^>]*>'

  for fullTestName, outcome in xml:gmatch(pattern) do
    -- Split the full test name into class name and test name
    local namespace, testName = fullTestName:match('(.*)%.([^.]*)')

    -- Handle cases where the test name does not contain a dot
    if not testName then
      namespace = ''
      testName = fullTestName
    end

    table.insert(results, { testName = testName, namespace = namespace, outcome = outcome })
  end

  return results
end

local function parseXmlFile(filepath)
  local results = {}

  local file = io.open(filepath, "r")
  if not file then
    print("Could not open file " .. filepath)
    return
  end

  for line in file:lines() do
    local res = parseXmlLine(line)
    for _, val in ipairs(res) do
      table.insert(results, val)
    end
  end

  -- Close the file
  file:close()

  return results
end


local function getOutcome(outcome)
  if outcome == "Passed" then
    return "✅"
  elseif outcome == "Failed" then
    return "❌"
  elseif outcome == "NotExecuted" then
    return "⏸ "
  end
  return "❓ Unknown"
end

local function populate_quickfix_from_file(filename)
  -- Open the file for reading
  local file = io.open(filename, "r")
  if not file then
    print("Could not open file " .. filename)
    return
  end

  -- Table to hold quickfix list entries
  local quickfix_list = {}

  -- Iterate over each line in the file
  for line in file:lines() do
    -- Match the pattern in the line
    local filepath, lnum, col, text = line:match("^(.+)%((%d+),(%d+)%)%: (.+)$")

    if filepath and lnum and col and text then
      -- Remove project file details from the text
      text = text:match("^(.-)%s%[.+$")

      -- Add the parsed data to the quickfix list
      table.insert(quickfix_list, {
        filename = filepath,
        lnum = tonumber(lnum),
        col = tonumber(col),
        text = text,
      })
    end
  end

  -- Close the file
  file:close()

  -- Set the quickfix list
  vim.fn.setqflist(quickfix_list)

  -- Open the quickfix window
  vim.cmd("copen")
end

local function groupByClassName(results)
  local grouped = {}

  for _, result in ipairs(results) do
    local namespace = result.namespace
    if not grouped[namespace] then
      grouped[namespace] = {}
    end
    table.insert(grouped[namespace], result)
  end

  return grouped
end

return {
  "GustavEikaas/easy-dotnet.nvim",
  -- dir = "C:\\Users\\Gustav\\repo\\easy-dotnet.nvim",
  dependencies = { "nvim-lua/plenary.nvim", 'nvim-telescope/telescope.nvim', },
  config = function()
    local logPath = vim.fn.stdpath "data" .. "/easy-dotnet/build.log"
    local dotnet = require("easy-dotnet")
    dotnet.setup({
      terminal = function(path, action)
        local commands = {
          run = function()
            return "dotnet run --project " .. path
          end,
          test = function()
            return "dotnet test " .. path
          end,
          restore = function()
            return "dotnet restore " .. path
          end,
          build = function()
            return "dotnet build " .. path .. " /flp:v=q /flp:logfile=" .. logPath
          end
        }

        if action == "build" then
          local command = commands[action]() .. "\r"
          vim.notify("Build started")
          vim.fn.jobstart(command, {
            on_exit = function(_, b, _)
              if b == 0 then
                vim.notify("Built successfully")
              else
                vim.notify("Build failed")
                populate_quickfix_from_file(logPath)
              end
            end,
          })
        elseif action == "test" then
          local command = commands[action]() .. "\r"
          vim.notify("Tests started")
          vim.fn.jobstart(command, {
            on_exit = function(_, b, _)
              if b == 0 then
                vim.notify("All tests passed")
              else
                vim.notify("Tests failed")
                populate_quickfix_from_file(logPath)
              end
            end,
          })
        else
          local command = commands[action]() .. "\r"
          vim.cmd("vsplit")
          vim.cmd("term " .. command)
        end
      end,
    })

    vim.api.nvim_create_user_command('Secrets', function()
      dotnet.secrets()
    end, {})

    vim.api.nvim_create_user_command("T", function()
      local debugger = require("general.debug")
      local res = parseXmlFile(
        "C:/Users/Gustav/repo/NeovimDebugProject/src/NeovimDebugProject.IntegrationTests/TestResults/easy-dotnet.trx")
      if res == nil then
        error("No output from xml file")
      end
      -- debugger.write_to_log(res)
      -- Create a new buffer
      local buf = vim.api.nvim_create_buf(false, true) -- false for not listing, true for scratch

      -- Set the new buffer as the current buffer in a new window
      vim.api.nvim_set_current_buf(buf)

      local grouped = groupByClassName(res)
      -- Insert text into the new buffer
      local lines = {}

      for key, testResults in pairs(grouped) do
        table.insert(lines, key)
        -- Iterate results here
        for _, testResult in pairs(testResults) do
          table.insert(lines, "  " .. getOutcome(testResult.outcome) .. " - " .. testResult.testName)
        end
        table.insert(lines, "")
      end

      vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    end, {})

    -- Temp
    vim.keymap.set("n", "<leader>r", dotnet.run_project)
    -- collides with breakpoints
    -- vim.keymap.set("n", "<leader>b", dotnet.build_solution)
    vim.keymap.set("n", "<leader>t", dotnet.test_solution)

    vim.keymap.set("n", "<C-p>", function()
      dotnet.run_project()
    end, {})
  end
}
