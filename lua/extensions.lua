local M = {}

M.isWindows = function()
  local platform = vim.loop.os_uname().sysname
  return platform == "Windows_NT"
end

return M
