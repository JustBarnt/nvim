---@class modules.lsp.lang.md
---@overload fun(config: vim.lsp.Config): vim.lsp.Config
local M = setmetatable({}, {
  __call = function(m, ...)
    return m.make_config(...)
  end,
})

M["md"] = {
  servers = { "marksman" },
  treesitters = { "markdown", "markdown_inline" },
  filetypes = { "markdown", "markdown.mdx" },
  settings = {},
}

local Config = {
  cmd = { "marksman", "server" },
  root_markers = { ".git" },
  filetypes = M.md.filetypes,
  capabilities = Helpers.lsp.create_capabilities(),
  on_init = function(client)
    Helpers.lsp.on_init(client, M.md.settings)
  end,
}

---@param config vim.lsp.Config
---@return vim.lsp.Config
function M.make_config(config)
  return LazyVim.merge({}, Config, config)
end

return M
