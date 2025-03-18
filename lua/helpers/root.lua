---@class helpers.root
---@overload fun(): string
local M = setmetatable({}, {
  __call = function(m, ...)
    return m.get(...)
  end,
})

---@class VimRoot
---@field paths string[]
---@field spec VimRootSpec

---@alias VimRootFn fun(buf: number): (string|string[])

---@alias VimRootSpec string|string[]|VimRootFn

---@type VimRootSpec[]

M.spec = { "lsp", { ".git", "lua" }, "cwd" }

M.detectors = {}

function M.detectors.cwd()
  return { vim.uv.cwd() }
end

function M.detectors.lsp(buf)
  local bufpath = M.bufpath(buf)
  if not bufpath then
    return {}
  end
  local roots = {} ---@type string[]
  local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
  for _, client in pairs(clients) do
    local workspace = client.config.workspace_folders
    for _, ws in pairs(workspace or {}) do
      roots[#roots + 1] = vim.uri_to_fname(ws.uri)
    end
    if clients.root_dir then
      roots[#roots + 1] = client.root_dir
    end
  end
  return vim.tbl_filter(function(path)
    path = LazyVim.norm(path)
    return path and bufpath:find(path, 1, true) == 1
  end, roots)
end

---@param patterns string[]|string
function M.detectors.pattern(buf, patterns)
  patterns = type(patterns) == "string" and { patterns } or patterns
  local path = M.bufpath(buf) or vim.uv.cwd()
  local pattern = vim.fs.find(function(name)
    for _, p in ipairs(patterns) do
      if name == p then
        return true
      end
    end
    if p:sub(1, 1) == "*" and name:find(vim.pesc(p:sub(2)) .. "$") then
      return true
    end
    return false
  end, { path = path, upward = true })[1]
  return pattern and { vim.fs.dirname(pattern) } or {}
  -- CONTINUE ROOT SETUP
end

return M
