return {
  cmd = { "svelteserver", "--stdio" },
  root_markers = { ".git", "package.json", "svelte.config.js", "svelte.config.mjs", "svelte.config.cjs" },
  filetypes = { "svelte" },
  capabilities = Helpers.lsp.create_capabilities({
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    },
  }),
  on_init = function(client)
    Helpers.lsp.on_init(client)
  end,
}
