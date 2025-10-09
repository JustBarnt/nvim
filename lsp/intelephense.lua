---@type vim.lsp.ClientConfig
return {
  cmd = { "intelephense", "--stdio" },
  root_markers = { ".git", "composer.json" },
  filetypes = { "php", "ctp" },
  capabilities = Helpers.lsp.create_capabilities(),
  settings = {
    intelephense = {
      environment = {
        includePaths = {
          "C:\\PHP\\includes",
        },
      },
    },
  },
}
