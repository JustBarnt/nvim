return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = function()
      local TS = require("nvim-treesitter")
      TS.update(nil, { summary = true })
    end,
    event = "VeryLazy",
    cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },
    opts_extend = { "esnure_installed" },
    opts = {
      -- stylua: ingnore start
      ensure_installed = {
        "bash", "blade", "c", "c_sharp", "cmake", "cpp", "css",
        "diff", "git_config", "gitcommit", "git_rebase", "gitignore",
        "gitattributes", "go", "gomod", "gosum", "gowork",
        "html", "html_tags", "ini", "javascript", "jsdoc", "json",
        "json5", "just", "lua", "luadoc",
        "luap", "markdown", "markdown_inline", "nu",
        "powershell", "prisma", "php", "printf", "query",
        "regex", "rust", "scheme", "scss", "sql", "svelte", "toml",
        "tsx", "typescript", "vim", "vimdoc", "xml", "yaml",
      }
      -- stylua: ingnore end
    },
    config = function(_, opts)
      local TS = require('nvim-treesitter')
      TS.setup(opts)

      Utils.treesitter.get_installed(true)

      local install = vim.tbl_filter(function(lang)
        return not Utils.treesitter.have(lang)
      end, opts.ensure_installed or {})

      if #install > 0 then
        TS.install(install, { summary = true }):await(function()
          Utils.treesitter.get_installed(true)
        end)
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("barnt/treesitter", { clear = true }),
        callback = function(ev)
          local ft, lang = ev.match, vim.treesitter.language.get_lang(ev.match)
          local filetype = vim.api.nvim_get_option_value("filetype", { buf = ev.buf })
          if not Utils.treesitter.have(ft) then
            return
          end

          if Utils.treesitter.have(ft, "highlights") then
            pcall(vim.treesitter.start, ev.buf)
          end

          if Utils.treesitter.have(ft, "indents") then
            vim.api.nvim_set_option_value("indentexpr", "v:lua.Utils.treesitter.indentexpr()", { scope = "local" })
          end

          if Utils.treesitter.have(ft, "folds") then
            vim.api.nvim_set_option_value("foldmethod", "expr", { scope = "local" })
            vim.api.nvim_set_option_value("foldexpr", "v:lua.Utils.treesitter.foldexpr()", { scope = "local" })
          end
        end
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    opts = {
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        -- Extension to create buffer-local keymaps - source: https://github.com/LazyVim/LazyVim/blob/c64a61734fc9d45470a72603395c02137802bc6f/lua/lazyvim/plugins/treesitter.lua#L148
        keys = {
          goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
          goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
          goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
        }
      }
    },
    config = function(_, opts)
      local TS = require("nvim-treesitter-textobjects")
      TS.setup(opts)

      local function attach(buf)
        local ft = vim.bo[buf].filetype
        if not (vim.tbl_get(opts, "move", "enable") and Utils.treesitter.have_query(ft, "textobjects")) then
          return
        end

        ---@type table<string, table<string, string>>
        local moves = vim.tbl_get(opts, "move", "keys") or {}

        for method, keymaps in pairs(moves) do
          for key, query in pairs(keymaps) do
            local queries = type(query) == "table" and query or { query }
            local parts = {}
            for _, q in ipairs(queries) do
              local part = q:gsub("@", ""):gsub("%..*", "")
              part = part:sub(1, 1):upper() .. part:sub(2)
              table.insert(parts, part)
            end
            local desc = table.concat(parts, " or ")
            desc = (key:sub(1, 1) == "[" and "Prev " or "Next ") .. desc
            desc = desc .. (key:sub(2, 2) == key:sub(2, 2):upper() and " End" or " Start")
            Snacks.keymap.set({ "n", "x", "o" }, key, function()
              require("nvim-treesitter-textobjects.move")[method](query, "textobjects")
            end, {
              buffer = buf,
              desc = desc,
              silent = true
            })
          end
        end
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("barnt/textobjects", { clear = true }),
        callback = function(ev)
          attach(ev.buf)
        end
      })
      vim.tbl_map(attach, vim.api.nvim_list_bufs())
    end
  }
}
