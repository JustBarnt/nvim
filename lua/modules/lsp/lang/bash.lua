---@class modules.lsp.lang.bash
---@overload fun(config: vim.lsp.Config): vim.lsp.Config
local M = setmetatable({}, {
  __call = function(m, ...)
    m.make_config(...)
  end,
})

local Config = {
  cmd = { "bash-language-server", "start" },
  root_markers = { ".bashrc", ".bash_profile", ".git" },
  filetypes = { "bash", "sh" },
  capabilities = Helpers.lsp.create_capabilities(),
  on_exit = Helpers.lsp.on_exit,
  on_error = Helpers.lsp.on_error,
  on_init = function(client)
    Helpers.lsp.on_init(client, M.bash.settings)
  end,
}

---@param config vim.lsp.Config
---@return vim.lsp.Config
function M.make_config(config)
  return LazyVim.merge({}, Config, config)
end

M["bash"] = {
  servers = { "bash-language-server", "shellcheck" },
  treesitters = { "bash" },
  filetypes = { "bash", "sh" },
  formatters = { "shfmt" },
  formatter_options = {},
  settings = {},
}

return M
