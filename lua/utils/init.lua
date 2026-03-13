---@class utils
---@field blink      utils.blink
---@field color      utils.color
---@field dap        utils.dap
---@field git        utils.git
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

---@param plugin string
function M.has(plugin)
  return M.get_plugin(plugin) ~= nil
end

---@param name string
function M.get_plugin(name)
  return require('lazy.core.config').spec.plugins[name]
end

---@param name string
function M.opts(name)
  local plugin = M.get_plugin(name)
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

return M
