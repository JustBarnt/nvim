return {
  {
    "DNLHC/glance.nvim",
    event = "VeryLazy",
    opts = {
      preview_win_opts = {
        number = false,
      },
      use_trouble_qf = true
    },
    config = function(_, opts)
      require("glance").setup(opts)
    end
  },
  {
    "justbarnt/buffer-sticks.nvim",
    event = "VeryLazy",
    opts = {
      show_by_default = true,
      show_indicators = true,
      border = "rounded",
      active_char = "",
      active_modified_char = "",
      inactive_char = "",
      inactive_modified_char = "",
      alternate_char = "",
      alternate_modified_char = "",
      label = { show = "always" },
      list = {
        show = { "filename", "space", "label" },
        active_indicator = "",
        keys = {
          move_up = "<C-p>",
          move_down = "<C-n>",
        },
        filter = {
          active_indicator = "",
          keys = {
            move_up = "<C-p>",
            move_down = "<C-n>",
          },
        }
      },
      preview = {
        float = {
          title = false,
          border = "rounded",
          footer = "filename"
        }
      },
      highlights = {
        active = { link = "Keyword" },
        alternate = { link = "StorageClass" },
        inactive = { link = "Whitespace" },
        active_modified = { link = "Constant" },
        alternate_modified = { link = "Constant" },
        inactive_modified = { link = "Constant" },
        label = { link = "Comment" },
        filter_selected = { link = "Keyword" },
        filter_title = { link = "Comment" },
        list_selected = { link = "Keyword" },
      }
    },
    keys = {
      {
        "<leader>b",
        function()
          BufferSticks.list()
        end,
        desc = "Show Buffers"
      },
    },
  },
  {
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
          disabled_filetypes = { statusline = { "snacks_dashboard" } },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },
          lualine_c = {
            Utils.lualine.root_dir(),
            {
              "diagnostics",
              symbols = {
                error = Config.ui.icons.diagnostics.Error,
                warn = Config.ui.icons.diagnostics.Warn,
                info = Config.ui.icons.diagnostics.Info,
                hint = Config.ui.icons.diagnostics.Hint,
              },
            },
            { "filetype",                 icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            { Utils.lualine.pretty_path() },
          },

          lualine_x = {
            Snacks.profiler.status(),
            -- stylua: ignore
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = function() return { fg = Utils.color.hl_to_hex("Special") } end,
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
            { "progress", separator = " ",                  padding = { left = 1, right = 0 } },
            { "location", padding = { left = 0, right = 1 } },
          },
          lualine_z = {
            function()
              return " " .. os.date("%R")
            end,
          },
        },
        extensions = { "lazy", "neo-tree" },
      }
      return opts
    end,
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    opts = {
      options = {
        show_source = {
          enabled = true,
        },
        use_icons_from_diagnostics = true,
      },
    }
  },
}
