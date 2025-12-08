---@class config.plugins.lualine
local M = {}

M.opts = {
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

return M
