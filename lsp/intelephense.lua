return {
  cmd = { "intelephense", "--stdio" },
  root_markers = { ".git", "composer.json" },
  filetypes = { "php", "ctp" },
  capabilities = Helpers.lsp.create_capabilities(),
  on_init = function(client)
    Helpers.lsp.on_init(client, {
      intelephense = {
        environment = {
          includePaths = {
            "C:\\PHP\\includes",
          },
        },
      },
    })
  end,
}
