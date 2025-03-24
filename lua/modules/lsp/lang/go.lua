---@class modules.lsp.lang.go
---@overload fun(config: vim.lsp.Config): vim.lsp.Config
local M = setmetatable({}, {
  __call = function(m, ...)
    return m.make_config(...)
  end,
})

M["go"] = {
  servers = { "gopls", "delve", "gomodifytags", "impl" },
  treesitters = { "go", "gomod", "gowork", "gosum" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  formatters = { "goimports", "gofumpt" },
  formatter_options = {},
  settings = {
    gopls = {
      gofumpt = true,
      codelenses = {
        gc_details = false,
        generate = true,
        regenerate_cgo = true,
        run_govulncheck = true,
        test = true,
        tidy = true,
        upgrade_dependecy = true,
        vendor = true,
      },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
      analyses = {
        nilness = true,
        unusedparams = true,
        unusedwrite = true,
        useany = true,
      },
      usePlaceholders = true,
      completeUnimported = true,
      staticcheck = true,
      directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
      semanticTokens = true,
    },
  },
}

local Config = {
  cmd = { "gopls" },
  root_markers = { "go.work", "go.mod", ".git" },
  filetypes = M.go.filetypes,
  capabilities = Helpers.lsp.create_capabilities(),
  on_exit = Helpers.lsp.on_exit,
  on_error = Helpers.lsp.on_error,
  on_init = function(client)
    Helpers.lsp.on_init(client, M.go.settings)
  end,
}

--- Returns a vim.lsp.Config that is merged with the given config else
--- returns the default
---@param config vim.lsp.Config
---@return vim.lsp.Config
function M.make_config(config)
  return LazyVim.merge({}, Config, config)
end

return M
