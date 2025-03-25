---@class modules.lsp.lang.lua
---@overload fun(config: vim.lsp.Config): vim.lsp.Config
local M = setmetatable({}, {
  ---@param config vim.lsp.Config
  __call = function(m, config)
    return m.make_config(config)
  end,
})

M.lua = {
  servers = { "lua-language-server", "stylua" },
  treesitters = { "lua", "luadoc", "luap" },
  filetypes = { "lua" },
  settings = {
    Lua = {
      codeLens = {
        enabled = true,
      },
      completion = {
        callSnippet = "Replace",
      },
      diagnostics = {
        globals = { "vim", "it", "describe" },
      },
      doc = {
        privateName = { "^_" },
      },
      hint = {
        enable = true,
        setType = false,
        paramType = true,
        paramName = "Disable",
        semicolon = "Disable",
        arrayIndex = "Disable",
      },
      runtime = {
        version = "LuaJIT",
      },
      telemetry = { enable = false },
      workspace = {
        checkThirdParty = false,
      },
    },
  },
}

---@class vim.lsp.Config
local Config = {
  cmd = { "lua-language-server" },
  name = "lua_ls",
  root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "selene.toml", "selene.yml", ".git" },
  filetypes = M.lua.filetypes,
  ---@type lsp.ClientCapabilities
  capabilities = Helpers.lsp.create_capabilities(),
  on_init = function(client)
    Helpers.lsp.on_init(client, M.lua.settings)
  end,
}

---@param config? vim.lsp.Config
function M.make_config(config)
  return LazyVim.merge({}, Config, config or {})
end

return M
