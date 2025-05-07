---@class helpers.lsp
local M = {}

---@class LspCommand: lsp.ExecuteCommandParams
---@field handler? lsp.Handler

---@param opts LspCommand
function M.execute(opts)
  local params = {
    command = opts.command,
    arguments = opts.arguments,
  }

  return vim.lsp.buf_request(0, "workspace/executeCommand", params, opts.handler)
end

M.action = setmetatable({}, {
  __index = function(_, action)
    return function()
      vim.lsp.buf.code_action({
        apply = true,
        context = {
          only = { action },
          diagnostics = {},
        },
      })
    end
  end,
})

---@param method vim.lsp.protocol.Method.ClientToServer|vim.lsp.protocol.Method.ServerToClient
function M.SupportsMethod(method)
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  for _, client in pairs(clients) do
    if client:supports_method(method, 0) then
      return true
    end
  end
  return false
end

---@param capabilities? vim.lsp.protocol.Method A list a client capabilities for an LSP
function M.create_capabilities(capabilities)
  local has_blink, blink = pcall(require, "blink.cmp")
  return vim.tbl_deep_extend(
    "force",
    vim.lsp.protocol.make_client_capabilities(),
    has_blink and blink.get_lsp_capabilities() or {},
    capabilities or {}
  )
end

---@param client vim.lsp.Client
---@param config? lsp.LSPObject
---@param opts? { merge: false }
function M.on_init(client, config, opts)
  local path = vim.tbl_get(client, "workspace_folders", 1, "name")
  if not path then
    return
  end

  client.settings = vim.tbl_deep_extend("force", client.settings, config or {})
end

return M
