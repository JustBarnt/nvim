---@class modules.lsp.lang.nu
---@overload fun(config: vim.lsp.Config): vim.lsp.Config
local M = setmetatable({}, {
  __call = function(m, ...)
    return m.make_config(...)
  end,
})

M["nu"] = {
  servers = {},
  treesitters = { "nu" },
  filetypes = { "nu" },
  settings = {},
}

local Config = {
  cmd = { "nu", "--lsp" },
  root_markers = { ".git" },
  filetypes = M.nu.filetypes,
  capabilities = Helpers.lsp.create_capabilities(),
  on_init = function(client)
    Helpers.lsp.on_init(client, M.nu.settings)
  end,
}

---@param config vim.lsp.Config
---@return vim.lsp.Config
function M.make_config(config)
  return LazyVim.merge({}, Config, config)
end

return M
