---@class modules.lsp.lang.svelte
---@overload fun(config: vim.lsp.Config): vim.lsp.Config
local M = setmetatable({}, {
  __call = function(m, ...)
    return m.make_config(...)
  end,
})

M["svelte"] = {
  servers = { "svelte-language-server", "prettier" },
  treesitters = { "svelte" },
  filetypes = { "svelte" },
  settings = {},
}

---@class vim.lsp.Config
local Config = {
  cmd = { "svelteserver", "--stdio" },
  root_markers = { ".git", "package.json", "svelte.config.js", "svelte.config.mjs", "svelte.config.cjs" },
  filetypes = M.svelte.filetypes,
  capabilities = Helpers.lsp.create_capabilities(),
  on_init = function(client)
    Helpers.lsp.on_init(client, M.svelte.settings)
  end,
}

---@param config vim.lsp.Config
function M.make_config(config)
  return LazyVim.merge({}, Config, config)
end

return M
