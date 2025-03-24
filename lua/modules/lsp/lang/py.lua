---@class modules.lsp.lang.py
---@overload fun(config: vim.lsp.Config): vim.lsp.Config
local M = setmetatable({}, {
  __call = function(m, ...)
    return m.make_config(...)
  end,
})

M["py"] = {
  servers = { "basedpyright", "ruff" },
  treesitters = { "python", "ninja", "rst" },
  formatters = { "black" },
  formatter_options = {},
  filetypes = { "python" },
  settings = {
    basedpyright = {
      disableOrganizedImports = true,
      analysis = {
        autoImportCompletions = true,
        autoSearchPaths = true,
        useLibraryForCodeTypes = true,
        diagnosticMode = "openFilesOnly",
      },
      inlayHints = {
        callArgumentNames = true,
      },
    },
  },
}

---@class vim.lsp.Config
local Config = {
  cmd = { "basedpyright-langserver", "--stdio" },
  name = "basedpyright",
  root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", "pyrightconfig.toml" },
  filetypes = M.py.filetypes,
  capabilities = Helpers.lsp.create_capabilities(),
  on_exit = Helpers.lsp.on_exit,
  on_error = Helpers.lsp.on_error,
  on_init = function(client)
    Helpers.lsp.on_init(client, M.py.settings)
  end,
}

---@param config? vim.lsp.Config
function M.make_config(config)
  return LazyVim.merge({}, Config, config or {})
end

return M
