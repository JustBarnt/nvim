---@class modules.lsp.lang.json
---@overload fun(config: vim.lsp.Config): vim.lsp.Config
local M = setmetatable({}, {
  __call = function(m, ...)
    return m.make_config(...)
  end,
})

M["json"] = {
  servers = { "json-lsp" },
  treesitters = { "json5", "json", "jsonc" },
  filetypes = { "json", "jsonc", "json5" },
  settings = {
    json = {
      format = {
        enable = true,
      },
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
}

---@class vim.lsp.Config
local Config = {
  cmd = { "vscode-json-language-server", "--stdio" },
  root_markers = { "*.json" },
  filetypes = M.json.filetypes,
  capabilities = Helpers.lsp.create_capabilities({
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = true,
        },
      },
    },
  }),
  init_options = {
    provideFormatter = true,
  },
  on_init = function(client)
    Helpers.lsp.on_init(client, M.json.settings)
    -- -- Lazy load schemastore
    -- M.json.settings.json.schemas = M.json.settings.json.schemas or {}
    -- vim.list_extend(M.json.settings.json.schemas, require("schemastore").json.schemas())
  end,
}

---@param config vim.lsp.Config
---@return vim.lsp.Config
function M.make_config(config)
  return LazyVim.merge({}, Config, config)
end

return M
