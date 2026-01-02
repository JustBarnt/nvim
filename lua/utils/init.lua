-- local LazyUtil = require("lazy.core.util")

---@class utils: LazyUtilCore
---@field color   utils.color
---@field keymaps utils.keymaps
---@field lualine utils.lualine
---@field root    utils.root
---@field wezterm utils.wezterm
local M = {}

setmetatable(M, {
  __index = function(t, k)
    -- if LazyUtil[k] then
    --   return LazyUtil[k]
    -- end

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

function M.is_win()
  return vim.uv.os_uname().sysname:find("Windows") ~= nil
end


return M
