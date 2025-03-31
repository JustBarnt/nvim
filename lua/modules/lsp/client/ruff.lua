local Ruff = {}

---@param client vim.lsp.Client
---@param keys LazyKeysSpec[]
function Ruff.setup(client, keys)
  assert(client.name == "ruff", ("Unknown Client: **%s**"):format(client.name))
  client.server_capabilities.hoverProvider = false
  vim.list_extend(keys, {
    {
      "<leader>co",
      Helpers.lsp.action["source.organizeImports"],
      "Organize Imports",
    },
  })
end

return Ruff
