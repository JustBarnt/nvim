---@type LSPConfig
return {
  servers = { "bash-language-server", "shellcheck" },
  treesitters = { "bash" },
  formatters = { "shfmt" },
  formatters_by_ft = { "shfmt" },
}
