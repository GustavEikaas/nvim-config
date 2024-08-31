---@class QueueItem
---@field method string
---@field params table


local rpc_state = {
  ---@type "idle" | "pending"
  state = "idle",
  call = nil,
  id = 0,
  ---@type "idle" | "pending"
  loop_state = "idle",
  ---@type QueueItem[]
  queue = {},
  ---@type file*
  pipe = nil
}

local function receive_rpc_response()
  local rpc_pipe = rpc_state.pipe
  if not rpc_pipe then
    print("pipe closed")
    return ""
  end

  local current_pos = rpc_pipe:seek()

  -- Seek to the end of the file
  local size = rpc_pipe:seek("end")

  -- Restore the original position
  rpc_pipe:seek("set", current_pos)

  -- Check if the file is empty
  if size == 0 then
    --Pipe is empty, skip
    return ""
  end

  local header = rpc_pipe:read("*l")
  local length = tonumber(header:match("Content%-Length: (%d+)"))

  local _ = rpc_pipe:read(2)

  local content = rpc_pipe:read(length)
  local response = vim.fn.json_decode(content)

  if response.id == rpc_state.id then
    print("" .. rpc_state.id .. " handled")
    print(string.format("%s finished", rpc_state.id))
    rpc_state.state = "idle"
  end

  print(content)
  return response
end


local function continuous_recieve()
  local timer = vim.loop.new_timer()

  timer:start(0, 5, function() -- Check every 1000 milliseconds (1 second)
    vim.schedule(receive_rpc_response)
  end)

  return timer
end

local function continuous_send()
  local timer = vim.loop.new_timer()

  timer:start(0, 1000, function() -- Check every 1000 milliseconds (1 second)
    vim.schedule(rpc_state.handler)
  end)

  return timer
end

rpc_state.call = function(method, params)
  if rpc_state.loop_state == "idle" then
    continuous_recieve()
    continuous_send()
    rpc_state.loop_state = "running"
  end
  if rpc_state.state == "pending" then
    print("still waiting for " .. rpc_state.id .. ". queuing...")
    table.insert(rpc_state.queue, { method = method, params = params })
  else
    table.insert(rpc_state.queue, { method = method, params = params })
  end
end

---@param method string
---@param params table
---@param id integer
local function send_rpc_request(method, params, id)
  rpc_state.state = "running"
  local rpc_pipe = rpc_state.pipe
  local request = {
    jsonrpc = "2.0",
    method = method,
    params = params,
    id = id
  }

  local request_str = vim.fn.json_encode(request)
  local content_length = #request_str

  -- Send the Content-Length header and the JSON-RPC payload
  rpc_pipe:write("Content-Length: " .. content_length .. "\r\n\r\n" .. request_str)
  rpc_pipe:flush()
  print("sending " .. method .. " id " .. id)
end


rpc_state.handler = function(request)
  if rpc_state.state == "idle" then
    if #rpc_state.queue > 0 then
      rpc_state.id = rpc_state.id + 1
      local curr = rpc_state.queue[1]
      table.remove(rpc_state.queue, 1)
      send_rpc_request(curr.method, curr.params, rpc_state.id)
    end
  end
end



local function connect_to_pipe(pipe_name)
  local pipe_path = pipe_name
  print("Attempting to open pipe: " .. pipe_path)

  -- Try to open the pipe in read+write mode
  local file, err = io.open(pipe_path, "r+b")

  if not file then
    print("Failed to open pipe: " .. err)
    return nil, err
  end

  print("Successfully opened pipe!")

  -- Store the file handle globally to keep it open
  rpc_state.pipe = file
  return file
end











return {
  "seblj/roslyn.nvim",
  commit = "5e36cac9371d014c52c4c1068a438bdb7d1c7987",
  config = function()
    require("roslyn").setup({
      config = {},
      exe = {
        "dotnet",
        vim.fs.joinpath(vim.fn.stdpath("data"), "roslyn", "Microsoft.CodeAnalysis.LanguageServer.dll"),
      },
      filewatching = true,
    })


    vim.keymap.set("n", "<leader>p", function()
      -- send_workspace_symbol_request("MathTests")
      -- send_rpc_request("textDocument/hover", vim.lsp.util.make_position_params(), function(result)
      --   print(vim.inspect(result))
      -- end)
    end, { noremap = true, silent = true })


    local default_lsp_args = { "--logLevel=Information", "--extensionLogDirectory=" ..
    vim.fs.dirname(vim.lsp.get_log_path()) }



    local dll_path = {
      "dotnet",
      vim.fs.joinpath(vim.fn.stdpath("data"), "roslyn", "Microsoft.CodeAnalysis.LanguageServer.dll")
    }


    local cmd = vim.list_extend({ dll_path }, default_lsp_args)

    local sln_parse = require("easy-dotnet.parsers.sln-parse")
    local solutionFilePath = sln_parse.find_solution_file()
    local absolute_solution_path = "C:/Users/Gustav/repo/NeovimDebugProject/src/NeovimDebugProject.sln"

    local sln_file = {
      directory = "C:/Users/Gustav/repo/NeovimDebugProject/src",
      files = {
        "C:/Users/Gustav/repo/NeovimDebugProject/src/NeovimDebugProject.sln"
      }
    }

    local capabilities = vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), {
      textDocument = {
        completion = {
          completionItem = {
            snippetSupport = true
          }
        },
        diagnostic = {
          dynamicRegistration = true
        }
      },
      workspace = {
        didChangeWatchedFiles = {
          dynamicRegistration = true
        }
      }
    })


    require("roslyn").start_with_solution(0, cmd, sln_file, {
        config = {},
        exe = {
          "dotnet",
          vim.fs.joinpath(vim.fn.stdpath("data"), "roslyn", "Microsoft.CodeAnalysis.LanguageServer.dll"),
        },
        filewatching = true,
      },
      function(pipe_name)
        connect_to_pipe(pipe_name)
        local rootUri = "file:///C:/Users/Gustav/repo/NeovimDebugProject"

        rpc_state.call("initialize",
          { rootUri = rootUri, capabilities = capabilities })

        rpc_state.call("project/open",
          {
            projects = {
              "file:///C:/Users/Gustav/repo/NeovimDebugProject/src/NeovimDebugProject.sln",
              -- "file:///C:/Users/Gustav/repo/NeovimDebugProject/src/NeovimDebugProject.ClassData/NeovimDebugProject.ClassData.csproj"
            }
          })

        rpc_state.call("workspace/symbol", {
          query = "0",
        })
      end)
  end
}
