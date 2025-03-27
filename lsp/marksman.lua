return {
  cmd = { "marksman", "server" },
  root_markers = { ".git" },
  filetypes = { "markdown", "markdown.mdx" },
  capabilities = Helpers.lsp.create_capabilities(),
}
