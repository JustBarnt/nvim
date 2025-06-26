---@type vim.lsp.ClientConfig
return {
  cmd = { 'just-lsp' },
  filetypes = { 'just' },
  root_markers = { '.git' }
}
