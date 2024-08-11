local resultIcons = {
  passed = "✔",
  skipped = "⏸",
  failed = "❌"
}


local function parseCountersLine(xml)
  local pattern =
  '<Counters%s+total="(%d+)"%s+executed="(%d+)"%s+passed="(%d+)"%s+failed="(%d+)"%s+error="(%d+)"%s+timeout="(%d+)"%s+aborted="(%d+)"%s+inconclusive="(%d+)"%s+passedButRunAborted="(%d+)"%s+notRunnable="(%d+)"%s+notExecuted="(%d+)"%s+disconnected="(%d+)"%s+warning="(%d+)"%s+completed="(%d+)"%s+inProgress="(%d+)"%s+pending="(%d+)"%s*/>'

  for total, executed, passed, failed, error, timeout, aborted, inconclusive, passedButRunAborted, notRunnable, notExecuted, disconnected, warning, completed, inProgress, pending in xml:gmatch(pattern) do
    return {
      total = tonumber(total),
      executed = tonumber(executed),
      passed = tonumber(passed),
      failed = tonumber(failed),
      error = tonumber(error),
      timeout = tonumber(timeout),
      aborted = tonumber(aborted),
      inconclusive = tonumber(inconclusive),
      passedButRunAborted = tonumber(passedButRunAborted),
      notRunnable = tonumber(notRunnable),
      notExecuted = tonumber(notExecuted),
      disconnected = tonumber(disconnected),
      warning = tonumber(warning),
      completed = tonumber(completed),
      inProgress = tonumber(inProgress),
      pending = tonumber(pending)
    }
  end

  return nil
end

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
  local results = {
    summary = {},
    tests = {}
  }

  local file = io.open(filepath, "r")
  if not file then
    print("Could not open file " .. filepath)
    return
  end

  for line in file:lines() do
    local res = parseXmlLine(line)
    for _, val in ipairs(res) do
      table.insert(results.tests, val)
    end

    local counters = parseCountersLine(line)
    if counters ~= nil then
      results.summary = counters
    end
  end

  -- Close the file
  file:close()

  return results
end


local function getOutcome(outcome)
  if outcome == "Passed" then
    return resultIcons.passed
  elseif outcome == "Failed" then
    return resultIcons.failed
  elseif outcome == "NotExecuted" then
    return resultIcons.skipped
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

local function linesForSummary(counters, buf, index, xml)
  local lines = {}
  table.insert(lines, xml)
  table.insert(lines, string.format("%s: %d", "Total", counters.total))
  table.insert(lines, string.format("%s: %d", "Passed", counters.passed))
  table.insert(lines, string.format("%s: %d", "Failed", counters.failed))
  table.insert(lines, "")

  vim.api.nvim_buf_set_lines(buf, -1, -1, true, lines)

  -- Apply highlights
  vim.api.nvim_buf_add_highlight(buf, -1, "Character", index + 3, string.len("Passed: "), -1)
  vim.api.nvim_buf_add_highlight(buf, -1, "DiagnosticError", index + 4, string.len("Failed: "), -1)
  return #lines
end


local function append_xml_contents(xml, buf, index)
  local res = parseXmlFile(xml)

  if res == nil then
    error("No output from xml file")
  end

  local grouped = groupByClassName(res.tests)

  local indexOffset = linesForSummary(res.summary, buf, index, xml)

  local lines = {}
  for key, testResults in pairs(grouped) do
    table.insert(lines, key)
    -- Iterate results here
    for _, testResult in pairs(testResults) do
      table.insert(lines, "  " .. getOutcome(testResult.outcome) .. " - " .. testResult.testName)
    end
    table.insert(lines, "")
  end

  table.insert(lines, "-------------------------------------------------------------------------")
  vim.api.nvim_buf_set_lines(buf, -1, -1, true, lines)
  return indexOffset + #lines
end

local function render_test_results(fileName, timestamp)
  local buf = vim.api.nvim_create_buf(false, true) -- false for not listing, true for scratch
  vim.api.nvim_set_current_buf(buf)

  local xmlReports = require("plenary.scandir").scan_dir(
    { vim.fn.getcwd() }, {
      search_pattern = "easy_dotnet_" .. timestamp .. ".trx",
      depth = 8
    })

  if xmlReports[1] == nil then
    vim.notify("no files found")
    return
  end

  local index = 0
  for _, file in pairs(xmlReports) do
    local indexOffset = append_xml_contents(file, buf, index)
    index = index + indexOffset
  end

  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  vim.api.nvim_buf_set_name(buf, 'easy-dotnet test results')
  vim.api.nvim_buf_set_option(buf, "filetype", "easy-dotnet")
end

local function generateRandomNumber(min, max)
  math.randomseed(os.time())
  return math.random(min, max)
end

local function trim(s)
  -- Match the string and capture the non-whitespace characters
  return s:match("^%s*(.-)%s*$")
end

local function expand_test_names_with_flags(test_names)
  local expanded = {}
  local seen = {}

  for _, full_test_name in ipairs(test_names) do
    local parts = {}
    local segment_count = 0

    -- Count the total number of segments
    for _ in full_test_name:gmatch("[^.]+") do
      segment_count = segment_count + 1
    end

    -- Reset the parts and segment_count for actual processing
    parts = {}
    local current_count = 0

    -- Split the test name by dot and process
    for part in full_test_name:gmatch("[^.]+") do
      table.insert(parts, part)
      current_count = current_count + 1
      local concatenated = trim(table.concat(parts, "."))

      if not seen[concatenated] then
        -- Set is_full_path to true only if we are at the last segment
        local is_full_path = (current_count == segment_count)
        table.insert(expanded,
          {
            value = concatenated,
            is_full_path = is_full_path,
            indent = current_count - 1,
            preIcon = is_full_path == false and "📂" or "🧪"
          })
        seen[concatenated] = true
      end
    end
  end

  return expanded
end

local function extract_tests(lines)
  local tests = {}

  -- Extract lines that match the pattern for test names
  for _, line in ipairs(lines) do
    if line:match("^%s*[%w%.]+%.[%w%.]+%.%w+%s*$") then
      table.insert(tests, line)
    end
  end


  return expand_test_names_with_flags(tests)
end

local function extract_test_results(line)
  local passed = line:match("Passed!")

  if passed ~= nil then
    return "Passed"
  end

  local skipped = line:match("Skipped!")

  if skipped ~= nil then
    return "Skipped"
  end

  local failed = line:match("Failed!")

  if failed ~= nil then
    return "Failed"
  end

  return nil
end

local function getIcon(res)
  if res == "Passed" then
    return resultIcons.passed
  elseif res == "Failed" then
    return resultIcons.failed
  elseif res == "Skipped" then
    return resultIcons.skipped
  end
end


local function peekStackTrace(index, lines)
  local stackTrace = {}
  for i, line in ipairs(lines) do
    if i > index then
      local testPattern = "(%w+) ([%w%.]+) %[(.-)%]"
      local newSection = line:match(testPattern)
      if newSection ~= nil then
        break
      else
        table.insert(stackTrace, line)
      end
    end
  end
  return stackTrace
end

local function run_test_suite(name, win)
  -- set all loading
  local matches = {}
  local suite_name = name
  for _, line in ipairs(win.lines) do
    if line.value:match(suite_name) then
      table.insert(matches, { ref = line, line = line.value })
      line.icon = "<Running>"
    end
  end
  win.refreshLines()
  vim.fn.jobstart(string.format("dotnet test --filter='%s' --nologo --no-build --no-restore ./src", suite_name), {
    on_stdout = function(_, data)
      if data == nil then
        error("Failed to parse dotnet test output")
      end
      for stdoutIndex, stdout in ipairs(data) do
        for _, match in ipairs(matches) do
          local failed = stdout:match(string.format("%s %s", "Failed", match.line))
          if failed ~= nil then
            match.ref.icon = resultIcons.failed
            match.ref.expand = peekStackTrace(stdoutIndex, data)
          end

          local skipped = stdout:match(string.format("%s %s", "Skipped", match.line))
          if skipped ~= nil then
            match.ref.icon = resultIcons.skipped
          end
        end
      end
      win.refreshLines()
    end,
    on_exit = function(_, code)
      -- If no stdout assume passed
      for _, test in ipairs(matches) do
        if (test.ref.icon == resultIcons.failed or test.ref.icon == resultIcons.skipped) then
        elseif test.ref.collapsable == false then
          test.ref.icon = resultIcons.passed
        end
      end

      -- Aggregate namespace status
      for _, namespace in ipairs(matches) do
        if (namespace.ref.collapsable == true) then
          local worstStatus = nil
          --TODO: check array for worst status
          for _, res in ipairs(matches) do
            if res.line:match(namespace.line) then
              if (res.ref.icon == resultIcons.failed) then
                worstStatus = resultIcons.failed
              elseif res.ref.icon == resultIcons.skipped then
                if worstStatus ~= resultIcons.failed then
                  worstStatus = resultIcons.skipped
                end
              end
            end
          end
          namespace.ref.icon = worstStatus == nil and resultIcons.passed or worstStatus
        end
      end
      win.refreshLines()
      if code ~= 0 then
        -- if (line.value:match("<Running>")) then
        --   line.value = original_line .. " <Panic! command failed>"
        --   win.refreshLines()
      end
      -- end
    end
  })
end

function slice(tbl, start_index)
  local sliced = {}
  for i = start_index, #tbl do
    table.insert(sliced, tbl[i])
  end
  return sliced
end

local keymaps = {
  ["E"] = function(_, _, win)
    for _, value in ipairs(win.lines) do
      value.hidden = false
    end
    win.refreshLines()
  end,
  ["W"] = function(_, _, win)
    for index, value in ipairs(win.lines) do
      if index ~= 1 then
        value.hidden = true
      end
    end
    win.refreshLines()
  end,
  ["o"] = function(index, line, win)
    if line.collapsable == false then
      return
    end

    local action = win.lines[index + 1].hidden == true and "expand" or "collapse"

    local newLines = {}
    for _, lineDef in ipairs(win.lines) do
      if lineDef.value:match(line.value) then
        if lineDef ~= line then
          lineDef.hidden = action == "collapse" and true or false
        end
      end
      table.insert(newLines, lineDef)
    end

    win.lines = newLines
    win.refreshLines()
  end,
  ["<leader>p"] = function(_, line)
    if line.expand == nil then
      return
    end
    local buf = vim.api.nvim_create_buf(false, true)
    local width = 70
    local height = 10

    local opts = {
      relative = 'editor',
      width = width,
      height = height,
      col = (vim.o.columns - width) / 2,
      row = (vim.o.lines - height) / 2,
      style = 'minimal',
      border = 'single',
    }
    local win = vim.api.nvim_open_win(buf, true, opts)
    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '<cmd>lua vim.api.nvim_win_close(' .. win .. ', true)<CR>',
      { noremap = true, silent = true })
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, line.expand)
    vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  end,
  ["<leader>r"] = function(_, line, win)
    if line.collapsable then
      run_test_suite(line.value, win)
      return
    end
    local original_line = line.value

    line.icon = "<Running>"
    vim.fn.jobstart(string.format("dotnet test --filter='%s' --nologo --no-build --no-restore ./src", original_line), {
      stdout_buffered = true,
      on_stdout = function(_, data)
        if data then
          local result = nil
          for index, stdout_line in ipairs(data) do
            local failed = stdout_line:match(string.format("%s %s", "Failed", line.value))
            if failed ~= nil then
              line.expand = peekStackTrace(index, data)
              result = "Failed"
            end
            local skipped = stdout_line:match(string.format("%s %s", "Skipped", line.value))

            if skipped ~= nil then
              result = "Skipped"
            end
          end
          if result == nil then
            result = "Passed"
          end

          line.icon = getIcon(result)
          win.refreshLines()
        end
      end,
      on_exit = function(_, code)
        if code ~= 0 then
          if (line.icon == "<Running>") then
            line.icon = "<Panic! command failed>"
            win.refreshLines()
          end
        end
      end
    })

    win.refreshLines()
  end
}

return {
  "GustavEikaas/easy-dotnet.nvim",
  -- dir = "C:\\Users\\Gustav\\repo\\easy-dotnet.nvim",
  dependencies = { "nvim-lua/plenary.nvim", 'nvim-telescope/telescope.nvim', },
  config = function()
    local logPath = vim.fn.stdpath "data" .. "/easy-dotnet/build.log"
    local dotnet = require("easy-dotnet")

    local test_timestamp = generateRandomNumber(0, 100000000)
    local fileName = string.format("easy-dotnet-%s.trx", test_timestamp)

    dotnet.setup({
      terminal = function(path, action)
        local commands = {
          run = function()
            return "dotnet run --project " .. path
          end,
          test = function()
            test_timestamp = generateRandomNumber(0, 100000000)
            fileName = "easy_dotnet_" .. test_timestamp .. ".trx"
            return string.format('dotnet test %s --logger "trx;LogFileName=%s"', path, fileName)
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
            on_exit = function()
              render_test_results(fileName, test_timestamp)
            end,
          })
        else
          local command = commands[action]() .. "\r"
          vim.cmd("vsplit")
          vim.cmd("term " .. command)
        end
      end,
    })

    vim.api.nvim_create_user_command('T', function()
      local win = require("general.render")
      win.buf_name = "Test manager"
      win.filetype = "easy-dotnet"
      win.setKeymaps(keymaps).render()

      vim.fn.jobstart("dotnet test -t --nologo --no-build --no-restore ./src", {
        stdout_buffered = true,
        on_stdout = function(_, data)
          if data then
            local tests = extract_tests(data)
            local lines = {}
            for _, test in ipairs(tests) do
              table.insert(lines,
                {
                  value = test.value,
                  collapsable = test.is_full_path == false,
                  indent = test.indent,
                  preIcon = test.preIcon
                })
            end

            win.lines = lines
            win.height = #lines > 20 and 20 or #lines
            win.refresh()
          end
        end,
        on_exit = function(_, code)
          if code ~= 0 then
            win.lines = { value = "Failed to discover tests" }
            win.refreshLines()
          end
        end
      })
    end, {})


    vim.api.nvim_create_user_command('Secrets', function()
      dotnet.secrets()
    end, {})

    -- Temp
    -- vim.keymap.set("n", "<leader>r", dotnet.run_project)
    -- collides with breakpoints
    -- vim.keymap.set("n", "<leader>b", dotnet.build_solution)
    vim.keymap.set("n", "<leader>t", dotnet.test_solution)

    vim.keymap.set("n", "<C-p>", function()
      dotnet.run_project()
    end, {})
  end
}
