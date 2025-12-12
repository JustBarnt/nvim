---@type vim.lsp.Config
return {
  cmd = { "intelephense", "--stdio" },
  root_markers = { ".git", "composer.json", ".svn" },
  filetypes = { "php", "ctp" },
  init_options = {
    licenseKey = "~/intelephense/licence.txt"
  },
  settings = {
    intelephense = {
      files = {
        associations = { "*.php", "*.inc.php" }
      }
    }
  },
  on_attach = function(client, bufnr)
    -- NOTE: USE TREESITTER INDENT FOR PHP. Intelephense's `GetPhpIndent()`
    --       SUCKS
    vim.bo[bufnr].indentexpr = "nvim_treesitter#indent()"
  end,
}
