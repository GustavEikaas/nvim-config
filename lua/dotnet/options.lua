return {
  secrets = {
    on_select = function(selectedItem)
      local home_dir = vim.fn.expand('~')
      local secret_path = home_dir ..
          '\\AppData\\Roaming\\Microsoft\\UserSecrets\\' .. selectedItem.secrets .. "\\secrets.json"
      vim.cmd("edit " .. vim.fn.fnameescape(secret_path))
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
