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
    "markdown.mdx",
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
    vim.keymap.set("n", "<leader>cf",
      function()
        LazyVim.try(function()
          return require("conform").format { bufnr = buffer }
        end, { msg = "[conform.nvim] failed to format" })
      end,
      { desc = "Format File" }
    )

    Helpers.lsp.on_init(client, {
      harper_ls = {
        codeActions = {
          ForceStable = true,
        },
        linters = {
          BoringWords = true,
          LinkingVerbs = true,
          SentenceCapitalization = false,
          SpellCheck = true,
          SpelledNumbers = true,
        },
      },
    })
  end,
}
