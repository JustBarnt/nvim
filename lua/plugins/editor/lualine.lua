return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      -- set empty statusline until lualine loads
      vim.o.statusline = " "
    else
      -- Hide statusbar on starter page
      vim.o.laststatus = 0
    end
  end,
  opts = function()
    -- PERF:https://github.com/LazyVim/LazyVim/blob/c64a61734fc9d45470a72603395c02137802bc6f/lua/lazyvim/plugins/ui.lua#L79
    local lualine_require = require("lualine_require")
    lualine_require.require = require

    local icons = Config.ui.icons
    vim.o.laststatus = vim.g.lualine_laststatus

    local opts = {
      options = {
        theme = "onedark",
        globalstatus = vim.o.laststatus == 3,
        disabled_filetypes = { statusline = { "snacks_dashboard", "snacks_picker_list" } },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = {
          { "filename", file_status = false, path = 1 },
          {
            "diagnostics",
            symbols = {
              error = Config.ui.icons.diagnostics.Error,
              warn = Config.ui.icons.diagnostics.Warn,
              info = Config.ui.icons.diagnostics.Info,
              hint = Config.ui.icons.diagnostics.Hint,
            },
          },
          { "filetype", icon_only = true, separator = " ", padding = { left = 1, right = 0 } },
        },

        lualine_x = {
          Snacks.profiler.status(),
          -- stylua: ignore
          {
            require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
            color = function() return { fg = Snacks.util.color("Special") } end,
          },
          {
            "diff",
            symbols = {
              added = Config.ui.icons.git.added,
              modified = Config.ui.icons.git.modified,
              removed = Config.ui.icons.git.removed,
            },
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
          },
        },
        lualine_y = {
          { "progress", separator = " ", padding = { left = 1, right = 0 } },
          { "location", padding = { left = 0, right = 1 } },
        },
        lualine_z = {
          function()
            return " " .. os.date("%R")
          end,
        },
      },
      extensions = { "lazy" },
    }
    return opts
  end,
  config = function(_, opts)
    vim.o.laststatus = vim.g.lualine_laststatus
    require("lualine").setup(opts)
  end
}
