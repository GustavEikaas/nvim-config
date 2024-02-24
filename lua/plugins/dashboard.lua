return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  config = function()
    local logo = [[
         _____           _              
        / ____|         | |             
        | |  __ _   _ ___| |_ __ ___   __
        | | |_ | | | / __| __/ _` \ \ / /
        | |__| | |_| \__ \ || (_| |\ V / 
        \_____|\__,_|___/\__\__,_| \_/  
      ]]

			logo = string.rep("\n", 8) .. logo .. "\n\n"
			-- opts.config.header = vim.split(logo, "\n")
    require('dashboard').setup {
      disable_move = true,
      config = {
        header = vim.split(logo, "\n")
      }
    }
  end,
  dependencies = { {'nvim-tree/nvim-web-devicons'}}
}
