local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local lsp = vim.lsp
local map = Snacks.keymap

---@class utils.lsp
local M = {}

---@param lsp string
function M.get_lsp_config(lsp)
  local ok, ret = pcall(require, "lua.servers." .. lsp)
  if ok then
    return ret
  else
    return {}
  end
end

---@param ev vim.api.keyset.create_autocmd.callback_args
function M.keymaps(ev)
  local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
  -- Lsp Keymaps
  map.set("n", "K", function() require("hover").open() end, { desc = "Hover", buffer = ev.buf })
  map.set("n", "gk", function() require("hover").enter() end, { desc = "Enter Hover Float", buffer = ev.buf })
  map.set("n", "gd", "<CMD>Glance definitions<CR>", { desc = "Goto Definition", buffer = ev.buf })
  map.set("n", "gD", function() Snacks.picker.lsp_declarations() end, { desc = "Goto Declaration", buffer = ev.buf })
  map.set("n", "grr", "<CMD>Glance references<CR>", { desc = "Goto References", buffer = ev.buf })
  map.set("n", "grt", "<CMD>Glance type_definitions<CR>", { desc = "Goto Type Definition", buffer = ev.buf })
  map.set("n", "grs", "<CMD>Trouble symbols toggle focus=false<CR>", { desc = "Document Symbols", buffer = ev.buf })
  map.set("n", "gri", "<CMD>Glance implementations<CR>", { desc = "Goto Implementation", buffer = ev.buf })
  map.set("i", "<C-s>", lsp.buf.signature_help, { desc = "Signature Helper", buffer = ev.buf })
  map.set("n", "grn", lsp.buf.rename, { desc = "Symbol Rename", buffer = ev.buf })
  map.set("n", "grf", lsp.buf.format, { desc = "Code Format", buffer = ev.buf })
  map.set("n", "grh", lsp.buf.typehierarchy, { desc = "Show Type Hierarchy", buffer = ev.buf })
  map.set({ "n", "v" }, "gra", require("tiny-code-action").code_action, { desc = "Code Actions", buffer = ev.buf, silent = true, noremap = true })

  -- Rust Lsp Keymaps
  map.set({ "n", "v" }, "gra", function() vim.cmd.RustLsp('codeAction') end, { desc = "Rust Code Actions", lsp = { name = "rust-analyzer" }, buffer = ev.buf })
  map.set("n", "K", function() vim.cmd.RustLsp({ 'hover', 'actions' }) end, { desc = "Rust Hover", lsp = { name = "rust-analyzer" }, buffer = ev.buf })
  map.set("n", "<leader>rr", function() vim.cmd.RustLsp('runnables') end, { desc = "Show All Runnables", lsp = { name = "rust-analyzer" }, buffer = ev.buf })
  map.set("n", "<leader>rR", function() vim.cmd.RustLsp({ 'runnables', bang = true }) end, { desc = "Rerun Last Runnable", lsp = { name = "rust-analyzer" }, buffer = ev.buf })
  map.set("n", "<leader>run", function() vim.cmd.RustLsp('run') end, { desc = "Run (Current Position)", lsp = { name = "rust-analyzer" }, buffer = ev.buf })
  map.set("n", "<leader>rd", function() vim.cmd.RustLsp('debuggables') end, { desc = "Debuggables", lsp = { name = "rust-analyzer" }, buffer = ev.buf })
  map.set("n", "<leader>rD", function() vim.cmd.RustLsp({ 'debuggables', bang = true }) end, { desc = "Rerun Last Debuggable", lsp = { name = "rust-analyzer" }, buffer = ev.buf })
  map.set("n", "<leader>dbg", function() vim.cmd.RustLsp('debug') end, { desc = "Debug (current context)", lsp = { name = "rust-analyzer" }, buffer = ev.buf })
  map.set("n", "<leader>rt", function() vim.cmd.RustLsp('testables') end, { desc = "Testables", lsp = { name = "rust-analyzer" }, buffer = ev.buf })
  map.set("n", "<leader>rT", function() vim.cmd.RustLsp({ 'testables', bang = true }) end, { desc = "Rerun Last Testable", lsp = { name = "rust-analyzer" }, buffer = ev.buf })
  map.set("n", "<leader>re", function() vim.cmd.RustLsp('explainError') end, { desc = "Explain Error", lsp = { name = "rust-analyzer" }, buffer = ev.buf })
  map.set("n", "<leader>rec", function() vim.cmd.RustLsp({ 'explainError', 'cycle' }) end, { desc = "Explain Error (cycle)", lsp = { name = "rust-analyzer" }, buffer = ev.buf })
  map.set("n", "<leader>rep", function() vim.cmd.RustLsp({ 'explainError', 'cycle_prev' }) end, { desc = "Explain Error (prev)", lsp = { name = "rust-analyzer" }, buffer = ev.buf })
  map.set("n", "<leader>rc", function() vim.cmd.RustLsp('openCargo') end, { desc = "Open Cargo.toml", lsp = { name = "rust-analyzer" }, buffer = ev.buf })
  map.set("n", "J", function() vim.cmd.RustLsp('joinLines') end, { desc = "Join Lines", lsp = { name = "rust-analyzer" }, buffer = ev.buf })
  map.set("n", "<leader>rs", function() vim.cmd.RustLsp('syntaxTree') end, { desc = "Syntax Tree", lsp = { name = "rust-analyzer" }, buffer = ev.buf })
  map.set("n", "<leader>rw", function() vim.cmd.RustLsp('reloadWorkspace') end, { desc = "Reload Workspace", lsp = { name = "rust-analyzer" }, buffer = ev.buf })
  map.set("n", "<leader>rsr", function() vim.cmd.RustLsp('ssr') end, { desc = "Structural Search Replace", lsp = { name = "rust-analyzer" }, buffer = ev.buf })
  map.set("n", "<leader>rws", function() vim.cmd.RustLsp('workspaceSymbol') end, { desc = "Workspace Symbol", lsp = { name = "rust-analyzer" }, buffer = ev.buf })
  map.set("n", "<leader>rrd", function() vim.cmd.RustLsp('relatedDiagnostics') end, { desc = "Related Diagnostics", lsp = { name = "rust-analyzer" }, buffer = ev.buf })
end

function M.progress()
  ---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
  local progress = vim.defaulttable()

  vim.api.nvim_create_autocmd("LspProgress", {
    ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin"|"report"|"end"}]]
      if not client or type(value) ~= "table" then
        return
      end
      local p = progress[client.id]

      for i = 1, #p + 1 do
        if i == #p + 1 or p[i].token == ev.data.params.token then
          p[i] = {
            token = ev.data.params.token,
            msg = ("[%3d%%] %s%s"):format(
              vim.kind == "end" and 100 or value.percentage or 100,
              value.title or "",
              value.message and (" **%s**"):format(value.message) or ""
            ),
            done = value.kind == "end"
          }
          break
        end
      end

      local msg = {} ---@type string[]
      progress[client.id] = vim.tbl_filter(function(v)
        return table.insert(msg, v.msg) or not v.done
      end, p)

      local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
      vim.notify(table.concat(msg, "\n"), vim.log.levels.INFO, {
        id = "lsp_progress",
        title = client.name,
        opts = function(notif)
          notif.icon = #progress[client.id] == 0 and " "
            or spinner[math.floor(vim.uv.hrtime() /(1e6 * 80)) % #spinner + 1]
        end
      })
    end
  })
end

-- Capability-based actions
local capability_actions = {
  completionProvider = function(client, buf)
    vim.bo[buf].omnifunc = "v:lua.vim.lsp.omnifunc"
  end,

  definitionProvider = function(client, buf)
    vim.bo[buf].tagfunc = "v:lua.vim.lsp.tagfunc"
  end,

  colorProvider = function(client, buf)
    local ok = pcall(function() vim.lsp.document_color.enable(true, buf, { style = "virtual" }) end)
    if not ok then
      vim.notify(("Client `%s` does not support `document_color`"):format(client.name), vim.log.levels.INFO)
    end
  end,

  codeLensProvider = function(client, buf)
    local ok = pcall(vim.lsp.codelens.refresh)
    if not ok then
      vim.notify(("Client `%s` does not support `codelens`"):format(client.name), vim.log.levels.INFO)
    end
  end,
}

--- Creates Client Capabilities
---@return lsp.ClientCapabilities
function M.create_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = true,
    lineFoldingOnly = true,
  }

  capabilities.textDocument.semanticTokens = nil
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  local ok, blink = pcall(require, "blink.cmp")
  if ok then
    capabilities = blink.get_lsp_capabilities(capabilities)
  end

  return capabilities
end

---Sets up capability based actions
---@param client vim.lsp.Client
function M.setup_server_capabilities(client, buf)
  for capability, action in pairs(capability_actions) do
    if client.server_capabilities[capability] then
      action(client, buf)
    end
  end
end

---Enables Client Methods if supported
---@param client vim.lsp.Client
---@param buf    integer
function M.setup_client_methods(client, buf)
  local methods = vim.lsp.protocol.Methods
  if client:supports_method(methods.textDocument_documentHighlight, buf) then
    autocmd({"CursorHold", "CursorHoldI"}, {
      group = augroup("barnt/lsp_doc_highlight", { clear = false }),
      buffer = buf,
      callback = lsp.buf.document_highlight
    })

    autocmd({"CursorMoved", "CursorMovedI"}, {
      group = augroup("barnt/lsp_doc_highlight", { clear = false }),
      buffer = buf,
      callback = lsp.buf.clear_references
    })
  end
end

return M
