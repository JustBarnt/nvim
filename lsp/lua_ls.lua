---@type vim.lsp.ClientConfig
return {
  cmd = { "lua-language-server" },
  root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "selene.toml", "selene.yml", ".git" },
  filetypes = { "lua" },
  capabilities = Helpers.lsp.create_capabilities(),
  on_init = function(client)
    table.insert(client.server_capabilities.executeCommandProvider.commands, "editor.action.showReferences")
    Helpers.lsp.on_init(client, {
      Lua = {
        codeLens = {
          enable = true,
        },
        completion = {
          callSnippet = "Disable",
          autoRequire = true,
          displayContext = 2,
        },
        doc = {
          privateName = { "^_" },
        },
        diagnostics = { disable = { "missing-fields" } },
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
