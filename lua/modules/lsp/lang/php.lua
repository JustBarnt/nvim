---@class modules.lsp.lang.php
---@overload fun(config: vim.lsp.Config): vim.lsp.Config
local M = setmetatable({}, {
  __call = function(m, ...)
    return m.make_config(...)
  end,
})

M["php"] = {
  servers = { "intelephense" },
  treesitters = { "php" },
  formatters = {},
  formatter_options = {},
  filetypes = { "php", "ctp" },
  settings = {
    intelephense = {
      environment = {
        includePaths = {
          "C:\\PHP\\includes",
        },
      },
    },
  },
}

local Config = {
  cmd = { "intelephense", "--stdio" },
  root_markers = { ".git", "composer.json" },
  filetypes = M.php.filetypes,
  capabilities = Helpers.lsp.create_capabilities(),
  on_init = function(client)
    Helpers.lsp.on_init(client, M.php.settings)
  end,
}

---@param config vim.lsp.Config
function M.make_config(config)
  return LazyVim.merge({}, Config, config)
end

return M
