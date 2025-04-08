return {
  cmd = { "vscode-json-language-server", "--stdio" },
  root_markers = { "*.json" },
  filetypes = { "json", "jsonc", "json5" },
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
    Helpers.lsp.on_init(client, {
      json = {
        format = {
          enable = true,
        },
        schemas = require("schemastore").json.schemas(),
        validate = { enable = true },
      },
    })
  end,
}
