---@type LSPConfig
return {
  servers = { "clangd" },
  treesitters = { "cpp", "c" },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
  formatters = {},
  formatter_options = {},
  keys = {
    { "<leader>ch", "<CMD>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
  },
}
