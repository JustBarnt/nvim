return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    main = "nvim-treesitter.configs",
    lazy = false,
    init = function(plugin)
      -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
      -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
      -- no longer trigger the **nvim-treesitter** module to be loaded in time.
      -- Luckily, the only things that those plugins need are the custom queries, which we make available
      -- during startup.
      require("lazy.core.loader").add_to_rtp(plugin)
      require "nvim-treesitter.query_predicates"
      ---@class ParserInfo[]
      local parsers = require("nvim-treesitter.parsers").get_parser_configs()
      parsers.lua_patterns = {
        install_info = {
          url = "https://github.com/OXY2DEV/tree-sitter-lua_patterns",
          files = { "src/parser.c" },
          branch = "main",
        },
      }

      parsers.ccic_transactions = {
        install_info = {
          url = "https://svnstore:3000/bwilliams/tree-sitter-ccic-transactions",
          files = { "src/parser.c" },
          branch = "main"
        },
        filetype = "cctrx"
      }
    end,
    keys = {
      { "<c-space>", desc = "Increment Selection" },
      { "<bs>", desc = "Decrement Selection", mode = "x" },
    },
    ---@type TSConfig
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      highlight = { enable = true, additional_vim_regex_highlighting = false },
      indent = { enable = true, disable = { "yaml" } },
      ensure_installed = {
        "bash",
        "c",
        "c_sharp",
        "cmake",
        "cpp",
        "diff",
        "git_config",
        "gitcommit",
        "git_rebase",
        "gitignore",
        "gitattributes",
        "go",
        "gomod",
        "gosum",
        "gowork",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "json5",
        "jsonc",
        "just",
        "lua",
        "luadoc",
        "luap",
        "lua_patterns",
        "markdown",
        "markdown_inline",
        "nu",
        "prisma",
        "php",
        "printf",
        "query",
        "regex",
        "scheme",
        "svelte",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      textobjects = {
        move = {
          enable = true,
          goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
          goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
          goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
        },
      },
    },
  },
  {
    "windwp/nvim-ts-autotag",
    event = "BufReadPre",
    opts = {
      aliases = {
        ["xaml"] = "xml",
        ["axaml"] = "xml",
      }
    },
  },
}
