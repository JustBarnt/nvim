return {
  cmd = { "lua-language-server" },
  root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "selene.toml", "selene.yml", ".git" },
  filetypes = { "lua" },
  ---@type lsp.ClientCapabilities
  capabilities = Helpers.lsp.create_capabilities({
    workspace = {
      fileOperations = {
        didRename = true,
        willRename = true,
      },
    },
  }),
  on_init = function(client)
    Helpers.lsp.on_init(client, {
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
    })
  end,
}
