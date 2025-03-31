local Svelte = {}
---@module "lazy"

---@param client vim.lsp.Client
---@param keys LazyKeysSpec[]
function Svelte.setup(client, keys)
  vim.list_extend(keys, { { "<leader>co", Helpers.lsp.action["source.organizeImports"], "Organize Imports" } })
end

return Svelte
