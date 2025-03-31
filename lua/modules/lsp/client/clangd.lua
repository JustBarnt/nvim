local Clangd = {}

---@param client vim.lsp.Client
---@param keys LazyKeysSpec[]
function Clangd.setup(client, keys)
  assert(client.name == "Clangd", ("Unknown Client: **%s**"):format(client.name))
  vim.list_extend(
    keys,
    { { "<leader>ch", "<CMD>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" } }
  )
end

return Clangd
