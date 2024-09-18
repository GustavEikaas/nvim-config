local M = {}

--- Rebuilds the project before starting the debug session
---@param co thread
local function rebuild_project(co, path)
  local num = 0;
  local spinner_frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }

  local notification = vim.notify(spinner_frames[1] .. " Building", "info", {
    timeout = false,
  })

  vim.fn.jobstart(string.format("dotnet build %s", path), {
    on_stdout = function(a)
      num = num + 1
      local new_spinner = (num) % #spinner_frames
      notification = vim.notify(spinner_frames[new_spinner + 1] .. " Building", "info",
        { replace = notification })
    end,
    on_exit = function(_, return_code)
      if return_code == 0 then
        vim.notify("Built successfully", "info", { replace = notification, timeout = 1000 })
      else
        -- HACK: clearing previous building progress message
        vim.notify("", "info", { replace = notification, timeout = 1 })
        vim.notify("Build failed with exit code " .. return_code, "error", { timeout = 1000 })
        error("Build failed")
      end
      coroutine.resume(co)
    end,
  })
  coroutine.yield()
end

local function run_job_sync(cmd)
  local result = {}
  local co = coroutine.running()

  vim.fn.jobstart(cmd, {
    stdout_buffered = false,
    on_stdout = function(_, data, _)
      for _, line in ipairs(data) do
        local match = string.match(line, "Process Id: (%d+)")
        if match then
          result.process_id = tonumber(match)
          coroutine.resume(co)
          return
        end
      end
    end,
  })

  coroutine.yield()

  return result
end

local function start_test_process()
  local test_file_dir = vim.fs.dirname(vim.fn.expand("%"))
  local command = string.format("dotnet test %s --environment=VSTEST_HOST_DEBUG=1", test_file_dir)
  local res = run_job_sync(command)
  if not res.process_id then
    error("Failed to start process")
  end
  return res.process_id
end

M.register_net_dap = function()
  local dap = require("dap")
  local dotnet = require("easy-dotnet")
  local debug_dll = nil

  local function ensure_dll()
    if debug_dll ~= nil then
      return debug_dll
    end
    local dll = dotnet.get_debug_dll()
    debug_dll = dll
    return dll
  end

  for _, value in ipairs({ "cs", "fsharp" }) do
    dap.configurations[value] = {
      {
        type = "coreclr",
        name = "Program",
        request = "launch",
        env = function()
          local dll = ensure_dll()
          local vars = dotnet.get_environment_variables(dll.project_name, dll.relative_project_path)
          return vars or nil
        end,
        program = function()
          local dll = ensure_dll()
          local co = coroutine.running()
          rebuild_project(co, dll.project_path)
          return dll.relative_dll_path
        end,
        cwd = function()
          local dll = ensure_dll()
          return dll.relative_project_path
        end
      },
      {
        type = "coreclr",
        name = "Test",
        request = "attach",
        processId = function()
          local process_id = start_test_process()
          -- vim.notify("debugging: " .. process_id)
          return process_id
        end,
        cwd = function()
          local dirname = vim.fs.dirname(vim.fn.expand("%"))
          return dirname
        end,

      }
    }
  end

  dap.listeners.before['event_terminated']['easy-dotnet'] = function()
    debug_dll = nil
  end

  dap.adapters.coreclr = {
    type = "executable",
    command = "netcoredbg",
    args = { "--interpreter=vscode" },
  }
end

return M
