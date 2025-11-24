---@class Keymaps
---@field base Keymaps.base
local M = {}

setmetatable(M, {
  __index = function(t, k)
    local ok, mod = pcall(require, "user.keymaps" .. k)
    if not ok then
      --stylua: ignore
      vim.notify(
        string.format("User keymaps module 'user.keymaps.%s' not found", k),
        vim.log.levels.ERROR
      )
      return nil
    end
    t[k] = mod
    return t[k]
  end,
})

return M
