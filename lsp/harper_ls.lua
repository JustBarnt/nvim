return {
  cmd = { "harper-ls", "--stdio" },
  root_markers = { ".git", "composer.json" },
  filetypes = {
    "c",
    "cpp",
    "gitcommit",
    "go",
    "html",
    "javascript",
    "lua",
    "markdown",
    "python",
    "rust",
    "toml",
    "typescript",
    "typescriptreact",
    "cmake",
    "php",
    "ctp",
    "c_sharp",
  },
  capabilities = Helpers.lsp.create_capabilities(),
  on_init = function(client)
    Helpers.lsp.on_init(client, {
      harper_ls = {
        linters = {
          SentenceCapitalization = false,
          SpellCheck = false,
        },
      },
    })
  end,
}
