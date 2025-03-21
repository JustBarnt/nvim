---@type LSPConfig
return {
  servers = { "bash-language-server", "shellcheck" },
  treesitters = { "bash" },
  filetypes = { "bash", "sh" },
  formatters = { "shfmt" },
}
