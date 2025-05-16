---@type vim.lsp.ClientConfig
return {
  cmd = { "nu", "--lsp" },
  root_markers = { ".git" },
  filetypes = { "nu" },
  workspace_required = false,
  capabilities = Helpers.lsp.create_capabilities(),
}
