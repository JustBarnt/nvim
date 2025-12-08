local ui = require("configurations.ui")

---@class config.diagnostics
local M = {}

M.config = {
  float = {
    border = "rounded",
    source = true,
    focusable = false,
    -- format = TODO: Setup this
  },
  jump = { on_jump = vim.diagnostic.open_float },
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = ui.icons.diagnostics.Error,
      [vim.diagnostic.severity.WARN] = ui.icons.diagnostics.Warn,
      [vim.diagnostic.severity.HINT] = ui.icons.diagnostics.Hint,
      [vim.diagnostic.severity.INFO] = ui.icons.diagnostics.Info,
    },
  },
  update_in_insert = true, -- If performance gets bad maybe disable this? Or disable it automatically in know lsps with poor performance like TS_LS
  underline = { severity = { vim.diagnostic.severity.ERROR, vim.diagnostic.severity.WARN } },
  virtual_text = false
  -- virtual_text = {
  --   spacing = 2,
  --   source = "if_many",
  --   prefix = ui.icons.misc.dot,
  --   severity = {
  --     min = vim.diagnostic.severity.WARN,
  --   },
  -- },
}

return M
