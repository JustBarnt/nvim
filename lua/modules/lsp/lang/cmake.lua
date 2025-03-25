---@class modules.lsp.lang.bash
---@overload fun(config: vim.lsp.Config): vim.lsp.Config
local M = setmetatable({}, {
  __call = function(m, ...)
    return m.make_config(...)
  end,
})

M["cmake"] = {
  servers = { "cmakelang", "cmakelint" },
  treesitters = { "cmake" },
  filetypes = { "bash", "sh" },
  settings = {},
}

local Config = {
  cmd = { "bash-language-server", "start" },
  root_markers = { ".bashrc", ".bash_profile", ".git" },
  filetypes = M.bash.filetypes,
  capabilities = Helpers.lsp.create_capabilities(),
  on_init = function(client)
    Helpers.lsp.on_init(client, M.bash.settings)
  end,
}

---@param config vim.lsp.Config
---@return vim.lsp.Config
function M.make_config(config)
  return LazyVim.merge({}, Config, config)
end

return M
