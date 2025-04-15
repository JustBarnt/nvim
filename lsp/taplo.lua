---@class vim.lsp.Config
return {
  cmd = { "taplo", "lsp", "stdio" },
  root_markers = { ".git" },
  filetypes = { "toml" },
}
