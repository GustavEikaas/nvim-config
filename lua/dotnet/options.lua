local platform = vim.loop.os_uname().sysname

return {
  secrets = {
    on_select = function(selectedItem)
      local home_dir = vim.fn.expand('~')
      --TODO: Make normalize path function to handle linux/windows
      if platform == "Windows" then
        local secret_path = home_dir ..
            '\\AppData\\Roaming\\Microsoft\\UserSecrets\\' .. selectedItem.secrets .. "\\secrets.json"
        vim.cmd("edit " .. vim.fn.fnameescape(secret_path))
      else
        local secret_path = home_dir .. "/.microsoft/usersecrets/" .. selectedItem.secrets .. "/secrets.json"
        vim.cmd("edit " .. vim.fn.fnameescape(secret_path))
      end
    end
  },
  run_project = {
    on_select = function(selectedItem)
      vim.cmd('terminal')
      local command = "dotnet run --project " .. selectedItem.path .. "\r\n"
      vim.api.nvim_feedkeys(command, 'n', true)
    end
  }
}
