---@class utils.wezterm
local M = {}

---@param var string
---@param value string
function M.set_wezterm_user_var(var, value)
  if not vim.env.WEZTERM_PANE then
    return
  end

  io.stdout:write(string.format("\027]1337;SetUserVar=%s=%s\007", var, vim.base64.encode(value)))
  io.stdout:flush()
end

return M
