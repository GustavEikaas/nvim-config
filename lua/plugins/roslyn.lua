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
  end
}
