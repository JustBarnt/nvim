local lsp_methods = vim.lsp.protocol.Methods
local client_methods = require("modules.lsp.client_capabilities")
local icons = require("core.ui.icons").icons

for _, file in ipairs(vim.fn.globpath("lsp", "*.lua", false, true)) do
  local basepath = vim.fn.fnamemodify(file, ":t:r")
  vim.lsp.enable(basepath)
end

-- a wrapper around client:supports_method for LSP capabilities
---@param client vim.lsp.Client
---@param method vim.lsp.protocol.Method
---@param bufnr? integer Some LSP's support methods in specific files
---@return boolean
local function client_supports_method(client, method, bufnr)
  return client:supports_method(method, bufnr)
end

-- TODO: Implement some more LSP type functions similar to LazyVim
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user-lsp-attach", { clear = true }),
  callback = function(ev)
    -- Attach generic LSP keymaps here
    local map = function(keys, func, desc, mode)
      mode = mode or "n"
      vim.keymap.set(mode, keys, func, { buffer = ev.buf, desc = "LSP: " .. desc })
    end

    -- stylua: ignore
		map("gd", function() Snacks.picker.lsp_definitions() end, "[G]oto [D]efinition")
    -- stylua: ignore
		map("gr", function() Snacks.picker.lsp_references() end, "[G]oto [R]eferences")
    -- stylua: ignore
		map("gI", function() Snacks.picker.lsp_implementations() end, "[G]oto [I]mplementation")
    -- stylua: ignore
		map("<leader>D", function() Snacks.picker.lsp_type_definitions() end, "Type [D]efinition")
    -- stylua: ignore
		map("<leader>ds", function() Snacks.picker.lsp_symbols() end, "[D]ocument [S]ymbols")
    -- stylua: ignore
		map("<leader>ws", function() Snacks.picker.lsp_workspace_symbols() end, "[W]orkspace [S]ymbols")
    -- stylua: ignore
		map("<leader>rn", function() Snacks.rename.rename_file() end, "[R]e[n]ame")
    -- stylua: ignore
		map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
    -- stylua: ignore
		map("gD", function() Snacks.picker.lsp_declarations() end, "[G]oto [D]eclaration")
    -- stylua: ignore
    map("<leader>cr", vim.lsp.buf.rename, "Rename Symbol")

    local has_conform, conform = pcall(require, "conform")

    -- Setup all potential lsp methods supported by the lsp
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client then
      -- workaround for gopls not supporting semanticTokensProvider
      -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
      if client.name == "gopls" and not client.server_capabilities.semanticTokensProvider then
        ---@class lsp.SemanticTokensClientCapabilities
        local semantic = client.config.capabilities.textDocument.semanticTokens
        client.server_capabilities.semanticTokensProvider = {
          full = true,
          legend = {
            tokenTypes = semantic.tokenTypes,
            tokenModifiers = semantic.tokenModifiers,
          },
          range = true,
        }
      end

      for _, method in pairs(lsp_methods) do
        ---@diagnostic disable-next-line param-type-mismatch
        if client_supports_method(client, method, ev.buf) and client_methods[method] then
          -- Sets up any configured LSP Protocol Methods
          client_methods[method](ev)
        end
      end
    end
    vim.diagnostic.config({
      severity_sort = true,
      underline = true,
      update_in_insert = false,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
          [vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
          [vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
          [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
        },
      },
      -- This is newly merged as of jan 2025, this displays diagnostic in a very similar way to nushell
      virtual_lines = {
        prefix = "●",
        current_line = true,
        spacing = 4,
        source = "if_many",
      },
    })
  end,
})

---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
local progress = vim.defaulttable()

vim.api.nvim_create_autocmd("LspProgress", {
  ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
    if not client or type(value) ~= "table" then
      return
    end
    local p = progress[client.id]

    for i = 1, #p + 1 do
      if i == #p + 1 or p[i].token == ev.data.params.token then
        p[i] = {
          token = ev.data.params.token,
          msg = ("[%3d%%] %s%s"):format(
            value.kind == "end" and 100 or value.percentage or 100,
            value.title or "",
            value.message and (" **%s**"):format(value.message) or ""
          ),
          done = value.kind == "end",
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
          or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
      end,
    })
  end,
})
