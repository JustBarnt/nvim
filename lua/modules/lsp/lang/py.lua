---@class modules.lsp.lang.py
---@overload fun(config: vim.lsp.Config): vim.lsp.Config
local M = setmetatable({}, {
  __call = function(m, ...)
    return m.make_config(...)
  end,
})

M["py"] = {
  servers = { "basedpyright", "ruff" },
  treesitters = { "python", "ninja", "rst" },
  formatters = { "black" },
  formatter_options = {},
  filetypes = { "python" },
  settings = {
    python = {
      pythonPath = vim.fn.exepath("python"),
    },
    basedpyright = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
      },
    },
  },
}

-- local function set_python_path(path)
--   local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf(), name = "basedpyright" })
--   for _, client in ipairs(clients) do
--     client.config.settings = vim.tbl_deep_extend("force", client.config.settings, { python = { pythonPath = path } })
--     client:notify("workspace/didChangeConfiguration", { settings = nil })
--   end
-- end

---@class vim.lsp.Config
local Config = {
  cmd = { "basedpyright-langserver", "--stdio" },
  name = "basedpyright",
  root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", "pyrightconfig.toml" },
  filetypes = M.py.filetypes,
  capabilities = Helpers.lsp.create_capabilities(),
  -- commands = {
  --   PyrightSetPythonPath = {
  --     set_python_path,
  --     description = "Reconfigure basedpyright with the provided python path",
  --     nargs = 1,
  --     complete = "file",
  --   },
  -- },
  on_init = function(client)
    Helpers.lsp.on_init(client, M.py.settings)
  end,
}

---@param config? vim.lsp.Config
function M.make_config(config)
  return LazyVim.merge({}, Config, config or {})
end

return M
