---@type LSPConfig
return {
  servers = { "lua-language-server" },
  treesitters = { "lua", "luadoc", "luap" },
  formatters = { "stylua" },
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
