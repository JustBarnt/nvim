---@class modules.lsp.lang.cmake
---@overload fun(config: vim.lsp.Config): vim.lsp.Config
local M = setmetatable({}, {
  __call = function(m, ...)
    return m.make_config(...)
  end,
})

M["cmake"] = {
  servers = { "cmakelang", "cmakelint" },
  treesitters = { "cmake" },
  filetypes = { "cmake" },
  settings = {},
}

local Config = {
  cmd = { "cmake-language-server" },
  root_markers = { "CMakePresets.json", "CTestConfig.cmake", "cmake", "build" },
  filetypes = M.cmake.filetypes,
  capabilities = Helpers.lsp.create_capabilities(),
  init_options = {
    buildDirectory = "build",
  },
  on_init = function(client)
    Helpers.lsp.on_init(client, M.cmake.settings)
  end,
}

---@param config vim.lsp.Config
---@return vim.lsp.Config
function M.make_config(config)
  return LazyVim.merge({}, Config, config)
end

return M
