local utils = require("modules.lsp.utils")
local cfg = require("modules.lsp.lang.lua")

---@type vim.lsp.Config
return {
  cmd = { "lua-language-server" },
  root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "selene.toml", "selene.yml", ".git" },
  filetypes = { "lua" },
  ---@type lsp.ClientCapabilities
  capabilities = utils.create_capabilities(),
  --- Note: This does not work, they will have to server capabilities will have to manually overwritten
  ---@type lsp.ServerCapabilities
  server_capabilities = {
    semanticTokensProvider = {
      full = false,
      legend = {
        tokenTypes = {},
        tokenModifiers = {},
      },
    },
  },
  on_exit = utils.on_exit,
  on_error = utils.on_error,
  on_init = function(client)
    utils.on_init(client, cfg.settings)
  end,
}
