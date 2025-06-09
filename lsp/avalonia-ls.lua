---@type vim.lsp.ClientConfig
return {
  name = "avalonia-ls",
  cmd = { "AvaloniaLanguageServer" },
  root_markers = { ".git", "App.axaml" },
  root_dir = vim.fn.getcwd(),
  filetypes = { "axaml" },
}
