local Svelte = {}

---@param client vim.lsp.Client
---@param keys LazyKeysSpec[]
function Svelte.setup(client, keys)
  client.capabilities.workspace.didChangeWatchedFiles = { dynamicRegistration = true }
  vim.list_extend(keys, { "<leader>co", Helpers.lsp.action["source.organizeImports"], "Organize Imports" })
end

return Svelte
