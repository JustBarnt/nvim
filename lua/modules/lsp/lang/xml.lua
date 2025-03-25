---@class modules.lsp.lang.php
---@overload fun(config: vim.lsp.Config): vim.lsp.Config
local M = setmetatable({}, {
  __call = function(m, ...)
    return m.make_config(...)
  end,
})

M["xml"] = {
  servers = { "lemminx", "xmlformatter" },
  treesitters = { "xml" },
  filetypes = { "xml", "xsd", "xsl", "xslt", "svg" },
  settings = {},
}

local Config = {
  cmd = { "lemminx" },
  root_markers = { ".git" },
  filetypes = M.xml.filetypes,
  capabilities = Helpers.lsp.create_capabilities(),
  on_init = function(client)
    Helpers.lsp.on_init(client, M.xml.settings)
  end,
}

---@param config vim.lsp.Config
function M.make_config(config)
  return LazyVim.merge({}, Config, config)
end

return M
