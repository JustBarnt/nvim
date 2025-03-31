return {
  cmd = { "nu", "--lsp" },
  root_markers = { ".git" },
  filetypes = { "nu" },
  capabilities = Helpers.lsp.create_capabilities(),
}
