local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local util = require("vim.lsp.util")
local ms = require("vim.lsp.protocol").Methods
local api = vim.api
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
  -- stylua: ignore start
  map.set("n", "K", vim.lsp.buf.hover, { desc = "Hover", buffer = ev.buf })
  map.set("n", "gd", "<CMD>Glance definitions<CR>", { desc = "Goto Definition", buffer = ev.buf })
  map.set("n", "gD", function() Snacks.picker.lsp_declarations() end, { desc = "Goto Declaration", buffer = ev.buf })
  map.set("n", "grr", "<CMD>Glance references<CR>", { desc = "Goto References", buffer = ev.buf })
  map.set("n", "grt", "<CMD>Glance type_definitions<CR>", { desc = "Goto Type Definition", buffer = ev.buf })
  map.set("n", "grs", "<CMD>Trouble symbols toggle focus=false<CR>", { desc = "Document Symbols", buffer = ev.buf })
  map.set("n", "gri", "<CMD>Glance implementations<CR>", { desc = "Goto Implementation", buffer = ev.buf })
  map.set("i", "<C-s>", lsp.buf.signature_help, { desc = "Signature Helper", buffer = ev.buf })
  map.set("n", "grn", lsp.buf.rename, { desc = "Symbol Rename", buffer = ev.buf })
  map.set("n", "grf", function() require("conform").format( { bufnr = ev.buf } ) end, { desc = "Code Format", buffer = ev.buf })
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
  -- stylua: ignore end
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
    local ok = pcall(function()
      vim.lsp.document_color.enable(true, buf, { style = "virtual" })
    end)
    if not ok then
      vim.notify(("Client `%s` does not support `document_color`"):format(client.name), vim.log.levels.INFO)
    end
  end,

  codeLensProvider = function(client, buf)
    local ok = pcall(vim.lsp.codelens.enable, true, { bufnr = buf })
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

  capabilities.textDocument.semanticTokens.multilineTokenSupport = true
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
    autocmd({ "CursorHold", "CursorHoldI" }, {
      group = augroup("barnt/lsp_doc_highlight", { clear = false }),
      buffer = buf,
      callback = lsp.buf.document_highlight,
    })

    autocmd({ "CursorMoved", "CursorMovedI" }, {
      group = augroup("barnt/lsp_doc_highlight", { clear = false }),
      buffer = buf,
      callback = lsp.buf.clear_references,
    })
  end
end

--                 ┐
--   LSP Overrides │
--                 ┘
local function client_positional_params(params)
  local win = api.nvim_get_current_win()
  return function(client)
    local ret = util.make_position_params(win, client.offset_encoding)
    if params then
      ret = vim.tbl_extend("force", ret, params)
    end
    return ret
  end
end

local function override_hover()
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.lsp.buf.hover = function(config)
    config = config or {}
    config.focus_id = ms.textDocument_hover
    local hover_ns = api.nvim_create_namespace("nvim.lsp.hover_range")
    lsp.buf_request_all(0, ms.textDocument_hover, client_positional_params(), function(results, ctx)
      local bufnr = assert(ctx.bufnr)
      if api.nvim_get_current_buf() ~= bufnr then
        -- Ignore result since buffer changed. This happens for slow language servers.
        return
      end
      -- Filter errors from results
      local results1 = {} --- @type table<integer,lsp.Hover>
      for client_id, resp in pairs(results) do
        local err, result = resp.err, resp.result
        if err then
          lsp.log.error(err.code, err.message)
        elseif result then
          results1[client_id] = result
        end
      end
      if vim.tbl_isempty(results1) then
        if config.silent ~= true then
          vim.notify("No information available")
        end
        return
      end
      local contents = {} --- @type string[]
      local nresults = #vim.tbl_keys(results1)
      local format = "markdown"
      for client_id, result in pairs(results1) do
        local client = assert(lsp.get_client_by_id(client_id))
        if nresults > 1 then
          -- Show client name if there are multiple clients
          contents[#contents + 1] = string.format("# %s", client.name)
        end
        if type(result.contents) == "table" and result.contents.kind == "plaintext" then
          if #results1 == 1 then
            format = "plaintext"
            contents = vim.split(result.contents.value or "", "\n", { trimempty = true })
          else
            -- Surround plaintext with ``` to get correct formatting
            contents[#contents + 1] = "```"
            vim.list_extend(contents, vim.split(result.contents.value or "", "\n", { trimempty = true }))
            contents[#contents + 1] = "```"
          end
        else
          vim.list_extend(contents, util.convert_input_to_markdown_lines(result.contents))
        end
        local range = result.range
        if range then
          local start = range.start
          local end_ = range["end"]
          local start_idx = util._get_line_byte_from_position(bufnr, start, client.offset_encoding)
          local end_idx = util._get_line_byte_from_position(bufnr, end_, client.offset_encoding)
          vim.hl.range(
            bufnr,
            hover_ns,
            "LspReferenceTarget",
            { start.line, start_idx },
            { end_.line, end_idx },
            { priority = vim.hl.priorities.user }
          )
        end
        contents[#contents + 1] = "---"
      end
      -- Remove last linebreak ('---')
      contents[#contents] = nil
      if vim.tbl_isempty(contents) then
        if config.silent ~= true then
          vim.notify("No information available")
        end
        return
      end
      local _, winid = lsp.util.open_floating_preview(contents, format, config)
      ---@diagnostic disable-next-line: undefined-field
      if config.winopts then
        ---@diagnostic disable-next-line: undefined-field
        for k, v in pairs(config.winopts) do
          vim.api.nvim_set_option_value(k, v, { win = winid })
        end
      end
      api.nvim_create_autocmd("WinClosed", {
        pattern = tostring(winid),
        once = true,
        callback = function()
          api.nvim_buf_clear_namespace(bufnr, hover_ns, 0, -1)
          return true
        end,
      })
    end)
  end
end

function M.init()
  override_hover()
end

return M
