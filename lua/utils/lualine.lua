---@class utils.lualine
local M = {}

M.components = {
  diffs = {
    "diff",
    symbols = {
      added = Utils.ui.icons.git.added,
      modified = Utils.ui.icons.git.modified,
      removed = Utils.ui.icons.git.removed,
    },
    separator = "",
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
  diags = {
    "diagnostics",
    symbols = {
      error = Utils.ui.icons.diagnostics.Error,
      warn = Utils.ui.icons.diagnostics.Warn,
      info = Utils.ui.icons.diagnostics.Info,
      hint = Utils.ui.icons.diagnostics.Hint,
    },
  },
  filename = {
    "filename",
    file_status = false,
    newfile_status = false,
    path = 1,
    symbols = {
      modified = Utils.ui.icons.git.modified,
      readonly = Utils.ui.icons.misc.lock,
      unnamed = "󰈔 ",
      newfile = "󰎔 ",
    },
    separator = "",
    padding = { left = 1, right = 0 },
  },
  lsp_status = {
    "lsp_status",
    icon = "󰣖",
    symbols = {
      spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
      done = "✓",
      separator = " ",
    },
    show_name = true,
  },
}

---@param icon string
---@param status fun(): nil|"ok"|"error"|"pending"
function M.status(icon, status)
  local colors = {
    ok = "Special",
    error = "DiagnosticError",
    pending = "DiagnosticWarn",
  }
  return {
    function()
      return icon
    end,
    cond = function()
      return status() ~= nil
    end,
    color = function()
      return { fg = Snacks.util.color(colors[status()] or colors.ok) }
    end,
  }
end

return M
