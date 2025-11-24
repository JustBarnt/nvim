---@class UserKeymaps
---@field [1] string[]        mode
---@field [2] string          lhs
---@field [3] string|function rhs
---@field [4] vim.keymap.set.Opts?          vim.api.keyset.keymap

local keys = require("user.keymaps")

local M = {}

M.set = {
  base = keys.base ---@as UserKeymaps[]
}

---@param set string
function M.activate(set)
  
end

return M
