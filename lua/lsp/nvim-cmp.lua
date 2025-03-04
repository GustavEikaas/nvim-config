local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

return {
  "hrsh7th/nvim-cmp",
  event = "LspAttach",
  enabled = false,
  dependencies = {
    { "hrsh7th/cmp-nvim-lsp",                 event = "LspAttach" },
    { "L3MON4D3/LuaSnip",                     event = "LspAttach" },
    { "saadparwaiz1/cmp_luasnip",             event = "LspAttach" },
    { "rafamadriz/friendly-snippets",         event = "LspAttach" },
    { 'kristijanhusak/vim-dadbod-completion', },
    { "petertriho/cmp-git" },
  },
  config = function()
    local cmp = require 'cmp'

    local luasnip = require("luasnip")
    require("luasnip.loaders.from_vscode").lazy_load()
    cmp.register_source("easy-dotnet", require("easy-dotnet").package_completion_source)

    cmp.setup({
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-z>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp',              priority = 1000 },
        { name = 'luasnip',               priority = 750 },
        { name = 'easy-dotnet' },
        { name = "vim-dadbod-completion", priority = 700 },
        { name = "buffer",                priority = 500 },
        { name = "path",                  priority = 250 },
      }),
    })

    cmp.setup.filetype('octo', {
      sources = cmp.config.sources({
        { name = 'git', priority = 1 }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
      }, {
        { name = 'buffer' },
      })
    })

    cmp.setup.filetype('gitcommit', {
      sources = cmp.config.sources({
        { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
      }, {
        { name = 'buffer' },
      })
    })

    cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' }
      }
    })

    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' }
      }, {
        { name = 'cmdline' }
      })
    })
    local format = require("cmp_git.format")
    local sort = require("cmp_git.sort")

    require("cmp_git").setup({
      -- defaults
      filetypes = { "gitcommit", "octo", "NeogitCommitMessage" },
      remotes = { "upstream", "origin" }, -- in order of most to least prioritized
      enableRemoteUrlRewrites = false,    -- enable git url rewrites, see https://git-scm.com/docs/git-config#Documentation/git-config.txt-urlltbasegtinsteadOf
      git = {
        commits = {
          limit = 100,
          sort_by = sort.git.commits,
          format = format.git.commits,
          sha_length = 7,
        },
      },
      github = {
        hosts = {}, -- list of private instances of github
        issues = {
          fields = { "title", "number", "body", "updatedAt", "state" },
          filter = "all", -- assigned, created, mentioned, subscribed, all, repos
          limit = 100,
          state = "open", -- open, closed, all
          sort_by = sort.github.issues,
          format = format.github.issues,
        },
        mentions = {
          limit = 100,
          sort_by = sort.github.mentions,
          format = format.github.mentions,
        },
        pull_requests = {
          fields = { "title", "number", "body", "updatedAt", "state" },
          limit = 100,
          state = "open", -- open, closed, merged, all
          sort_by = sort.github.pull_requests,
          format = format.github.pull_requests,
        },
      },
      gitlab = {
        hosts = {}, -- list of private instances of gitlab
        issues = {
          limit = 100,
          state = "opened", -- opened, closed, all
          sort_by = sort.gitlab.issues,
          format = format.gitlab.issues,
        },
        mentions = {
          limit = 100,
          sort_by = sort.gitlab.mentions,
          format = format.gitlab.mentions,
        },
        merge_requests = {
          limit = 100,
          state = "opened", -- opened, closed, locked, merged
          sort_by = sort.gitlab.merge_requests,
          format = format.gitlab.merge_requests,
        },
      },
      trigger_actions = {
        -- {
        --   debug_name = "git_commits",
        --   trigger_character = ":",
        --   action = function(sources, trigger_char, callback, params, git_info)
        --     return sources.git:get_commits(callback, params, trigger_char)
        --   end,
        -- },
        {
          debug_name = "github_issues_and_pr",
          trigger_character = "~",
          action = function(sources, trigger_char, callback, params, git_info)
            return sources.github:get_issues_and_prs(callback, git_info, trigger_char)
          end,
        },
        {
          debug_name = "github_mentions",
          trigger_character = "@",
          action = function(sources, trigger_char, callback, params, git_info)
            return sources.github:get_mentions(callback, git_info, trigger_char)
          end,
        },
      },
    }
    )
  end
}
