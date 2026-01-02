---@class utils.color
local M = {}

---@param string|string[] hl group to get color from
---@param prop? string property to get. Defaults to 'fg'
---@return string the hl propert converted to a hex
function M.hl_to_hex(group, prop)
  prop = prop or 'fg'
  group = type(group) == "table" and group or { group }
  ---@cast group string[]
  for _, g in ipairs(group) do
    local hl = vim.api.nvim_get_hl(0, { name = g, link = false, create = false })
    if hl[prop] then
      return string.format("#%06x", hl[prop])
    end
  end
end

return M
