---@class utils
---@field keymaps utils.keymaps
local M = {}

setmetatable(M, {
  __index = function(t, k)
    local ok, mod = pcall(require, "utils." .. k)
    if not ok then
      --stylua: ignore
      vim.notify(
        string.format("Utility module 'utils.%s' not found", k),
        vim.log.levels.ERROR
      )
      return nil
    end
    t[k] = mod
    return t[k]
  end,
})

return M
