local spotify = {}

spotify.setup = function()
  vim.api.nvim_create_user_command("Metal", function()
    os.execute "spt play --uri spotify:playlist:2Wk3JJp8MnQyKV1Uvr4Y0D --random"
  end, {})
  vim.api.nvim_create_user_command("Country", function()
    os.execute "spt play --uri spotify:playlist:7Lv78RoIVNlT7DidA4U4MW --random"
  end, {})
  vim.api.nvim_create_user_command("Rave", function()
    os.execute "spt play --uri spotify:playlist:6zmx9wViGZuF5AR1vDAdA3 --random"
  end, {})

  vim.keymap.set("n", "<leader>sn", function()
    vim.fn.jobstart "spt playback --next"
  end, { silent = true })

  vim.keymap.set("n", "<leader>sp", function()
    vim.fn.jobstart "spt playback --previous"
  end, { silent = true })
end

return spotify
