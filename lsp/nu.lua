---@type vim.lsp.ClientConfig
return {
  cmd = { "nu", "--lsp" },
  root_markers = { ".git" },
  root_dir = function(fname)
    return vim.fs.dirname(fname)
  end,
  flags = { debounce_text_changes = 1000 },
  filetypes = { "nu" },
  workspace_required = false,
  capabilities = Helpers.lsp.create_capabilities(),
}
