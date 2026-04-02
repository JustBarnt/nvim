---@class utils.wezterm
local M = {}

---@param var string
---@param value string
function M.set_wezterm_user_var(var, value)
  if not vim.env.WEZTERM_PANE then
    return
  end

  local seq = string.format("\027]1337;SetUserVar=%s=%s\007", var, vim.base64.encode(value))
  vim.api.nvim_ui_send(seq)
end

return M
