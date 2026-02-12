return {
  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    priority = 1000,
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

      local triforce = require("triforce.lualine").components()
      local icons = Utils.ui.icons
      vim.o.laststatus = vim.g.lualine_laststatus

      local opts = {
        options = {
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          globalstatus = vim.o.laststatus == 3,
          disabled_filetypes = { statusline = { "snacks_dashboard" } },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", Utils.lualine.components.diffs, Utils.lualine.components.diags },
          lualine_c = {
            Utils.lualine.components.filename,
            { "filetype", icon_only = true, separator = "" },
          },

          lualine_x = {
            { triforce.level, separator = "" },
            triforce.session_time,
          },
          lualine_y = {
            Utils.lualine.components.lsp_status,
          },
          lualine_z = {
            { "progress", separator = "", padding = { left = 0, right = 1 } },
            { "location", separator = "", padding = { left = 0, right = 1 } },
            {
              function()
                return " " .. os.date("%R")
              end,
              separator = "",
              padding = { left = 0, right = 0 },
            },
          },
        },
        extensions = { "lazy", "neo-tree" },
      }
      return opts
    end,
  },
}
