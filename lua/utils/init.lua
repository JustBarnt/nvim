---@class utils
---@field blink      utils.blink
---@field color      utils.color
---@field lsp        utils.lsp
---@field lualine    utils.lualine
---@field root       utils.root
---@field treesitter utils.treesitter
---@field ui         utils.ui
---@field wezterm    utils.wezterm
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

function M.is_win()
  return vim.uv.os_uname().sysname:find("Windows") ~= nil
end


return M
