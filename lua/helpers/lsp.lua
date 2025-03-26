---@class helpers.lsp
local M = {}

---@type lsp.ClientCapabilities
M.capabilities = {
  workspace = {
    fileOperations = {
      didRename = true,
      willRename = true,
    },
  },
}

M.format = {
  formatting_options = nil,
  timeout_ms = nil,
}

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

---@param client vim.lsp.Client
function M.fetch_workspaces(client)
  local path = vim.tbl_get(client, "workspace_folders", 1, "name")
  if not path then
    return nil
  end
  return path
end

---@param capabilities? vim.lsp.protocol.Method A list a client capabilities for an LSP
function M.create_capabilities(capabilities)
  local has_blink, blink = pcall(require, "blink.cmp")
  return vim.tbl_deep_extend(
    "force",
    vim.lsp.protocol.make_client_capabilities(),
    has_blink and blink.get_lsp_capabilities() or {},
    M.capabilities,
    capabilities or {}
  )
end

function M.on_exit(code, signal)
  vim.notify(string.format("LSP Client exited with code %d, signal %s", code, signal))
end

function M.on_error(code, msg)
  vim.notify(string.format("LSP Client error: %s (code: %s)", msg, code), vim.log.levels.ERROR)
end

---@param client vim.lsp.Client
---@param config? lsp.LSPObject
function M.on_init(client, config)
  if not M.fetch_workspaces(client) then
    return
  end

  client.settings = vim.tbl_deep_extend("force", client.settings, config or {})
end

return M
