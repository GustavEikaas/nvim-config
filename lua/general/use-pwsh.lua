local powershell_options = {
  shell = vim.fn.executable "pwsh" == 1 and "pwsh" or "powershell",
  shellcmdflag =
  "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
  shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait",
  shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
  shellquote = "",
  shellxquote = "",
}

local platform = vim.loop.os_uname().sysname
if platform == "Windows" then
  for option, value in pairs(powershell_options) do
    vim.opt[option] = value
  end
  vim.opt.shell = "powershell"
else
  vim.opt.shell = "/usr/bin/zsh"
end
