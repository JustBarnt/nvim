---@type LSPConfig
return {
  servers = { "intelephense" },
  treesitters = { "php" },
  formatters = {},
  formatter_options = {},
  filetypes = { "php", "ctp" },
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
