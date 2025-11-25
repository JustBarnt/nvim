---@class config.plugins.snacks
local M = {
  bufdelete = { enabled = true },
  dashboard = { enabled = true },
  explorer = {
    replace_netrw = true,
    trash = true
  },
  input = { enabled = true },
  lazygit = { enabled = vim.fn.has("lazygit") == 1 },
  notifier = {
    style = "minimal",
    refresh = 500,
    top_down = false,
  },
  notify = {
    enabled = true,
  },
  ---@class snacks.picker
  picker = {
    formatters = {
      file = {
        filename_first = true,
      },
    },
    sources = {
      explorer  = {
        layout = { preset = "sidebar", layout = { position = "right" } },
      }
    },
    win = {
      preview = {
        wo = {
          statuscolumn = "",
        },
      },
    },
  },
  statuscolumn = { enabled = true },
}

return M
