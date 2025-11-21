---@class PluginConfigs
---@field snacks PluginConfigs.snacks
---@field treesitter PluginConfigs.treesitter
local M = {}

setmetatable(M, {
  __index = function(t, k)
    local ok, mod = pcall(require, "plugins.configurations." .. k)
    if not ok then
      --stylua: ignore
      vim.notify(
        string.format("Configuration module 'configuration.%s' not found", k),
        vim.log.levels.ERROR
      )
      return nil
    end
    t[k] = mod
    return t[k]
  end,
})

return M
