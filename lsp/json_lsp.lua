---@type vim.lsp.ClientConfig
return {
  cmd = { "vscode-json-language-server", "--stdio" },
  root_markers = { "*.json" },
  filetypes = { "json", "jsonc", "json5" },
  capabilities = Helpers.lsp.create_capabilities {
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = true,
        },
      },
    },
  },
  init_options = {
    provideFormatter = true,
  },
  settings = {
    json = {
      format = {
        enable = true,
      },
      schemas = require("schemastore").json.schemas {
        extra = {
          {
            description = "CMakePresets",
            fileMatch = "CMakePresets.json",
            name = "CMakePresets.json",
            url = "https://raw.githubusercontent.com/Kitware/CMake/master/Help/manual/presets/schema.json",
          },
        },
      },
      validate = { enable = true },
    },
  },
}
