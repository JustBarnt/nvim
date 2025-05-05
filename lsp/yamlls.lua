---@type vim.lsp.Config
return {
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
  root_markers = { ".git" },
  capabilities = {
    textDocument = {
      foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      },
    },
  },
  settings = {
    -- https://github.com/redhat-developer/vscode-redhat-telemetry#how-to-disable-telemetry-reporting
    redhat = { telemetry = { enabled = false } },
    yaml = {
      keyOrdering = false,
      format = {
        enable = true,
      },
      validate = true,
      schemaStore = {
        enabled = false,
        url = "",
      }
    },
  },
  on_attach = function(client, buf)
    client.server_capabilities.documentFormattingProvider = true
  end,
  before_init = function(_, new_config)
    new_config.settings.yaml.schemas = vim.tbl_deep_extend(
      "force",
      new_config.settings.yaml.schemas or {},
      require("schemastore").yaml.schemas()
    )
  end,
}
