local map = Snacks.keymap

 vim.diagnostic.config({
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
      [vim.diagnostic.severity.ERROR] = Utils.ui.icons.diagnostics.Error,
      [vim.diagnostic.severity.WARN]  = Utils.ui.icons.diagnostics.Warn,
      [vim.diagnostic.severity.HINT]  = Utils.ui.icons.diagnostics.Hint,
      [vim.diagnostic.severity.INFO]  = Utils.ui.icons.diagnostics.Info,
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
})

---@param count integer
---@param severity? vim.diagnostic.Severity
local function diagnostic_goto(count, severity)
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    vim.diagnostic.jump { severity = severity, count = count }
  end
end

-- Diagnostic Keymaps
map.set("n", "gl", vim.diagnostic.open_float, { desc = "Line Diagnostic" })
map.set("n", "]d", diagnostic_goto(1), { desc = "Next Diagnostic" })
map.set("n", "[d", diagnostic_goto(-1), { desc = "Previous Diagnostic" })
map.set("n", "]e", diagnostic_goto(1, 1), { desc = "Next Error" })
map.set("n", "[e", diagnostic_goto(-1, 1), { desc = "Previous Error" })
map.set("n", "]w", diagnostic_goto(1, 2), { desc = "Next Warning" })
map.set("n", "[w", diagnostic_goto(-1, 2), { desc = "Previous Warning" })
