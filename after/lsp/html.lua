---@type vim.lsp.Config
return {
  filetypes = {
    "html",
    "blade",
    "javascriptreact",
    "typescriptreact",
    -- "svelte"
  },
  root_markers = {"index.html", ".git", "package.json"},
  init_options = {
    provideFormatter = true,
    embeddedLanguages = { javascript = true, css = true },
    configurationSection = { "html", "css", "javascript" }
  }
}
