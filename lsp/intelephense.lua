---@type vim.lsp.ClientConfig
return {
  cmd = { "intelephense", "--stdio" },
  root_markers = { ".git", "composer.json" },
  filetypes = { "php", "ctp" },
  capabilities = { },
  settings = {
    intelephense = {
      environment = {
        includePaths = {
          "C:\\PHP\\includes",
        },
      },
    },
  },
  on_attach = function(client, bufnr)
    -- NOTE: USE TREESITTER INDENT FOR PHP. Intelephense's `GetPhpIndent()`
    --       SUCKS
    vim.bo[bufnr].indentexpr = "nvim_treesitter#indent()"
  end,
}
