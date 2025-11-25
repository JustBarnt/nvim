---@class config.plugins
---@field lsp        config.plugins.lsp
---@field snacks     config.plugins.snacks
---@field treesitter config.plugins.treesitter
local M = {}

setmetatable(M, {
  __index = function(t, k)
    local ok, mod = pcall(require, "configurations.plugins." .. k)
    if not ok then
      --stylua: ignore
      vim.notify(
        string.format("Configuration module 'configuration.plugins.%s' not found", k),
        vim.log.levels.ERROR
      )
      return nil
    end
    t[k] = mod
    return t[k]
  end,
})

return M
