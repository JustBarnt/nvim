local M = {}
local api = vim.api
local client_methods = require "modules.lsp.client_capabilities"
local lsp_autocmds = require "modules.lsp.autocmds"
local lsp_commands = require "modules.lsp.user-commands"
local lsp_hover = require "modules.lsp.hover"

local lspgroup = api.nvim_create_augroup("lsp", {})

local function make_keymaps(buffer, keys)
  local function map(lhs, rhs, desc, mode)
    mode = mode or "n"
    vim.keymap.set(mode, lhs, rhs, { buffer = buffer, desc = "LSP: " .. desc })
  end

  for _, key in ipairs(keys) do
    if type(key) ~= "table" then
      vim.notify(
        ("Bad keymap. Expected key to be a table: **%s**\nSkipping this keymap"):format(key),
        vim.log.levels.WARN
      )
      goto continue
    end
    local lhs, rhs, desc, mode = unpack(key)
    map(lhs, rhs, desc, mode or nil)
    ::continue::
  end
end

function M.setup()
  local configs = {}
  local config_keys = {}

  for _, v in ipairs(vim.api.nvim_get_runtime_file("lsp/*", true)) do
    local name = vim.fn.fnamemodify(v, ":t:r")
    configs[name] = true
  end

  config_keys = vim.tbl_keys(configs)
  vim.lsp.enable(config_keys)

  lsp_commands.setup()

  api.nvim_create_autocmd("LspAttach", {
    group = lspgroup,
    callback = function(args)
      -- NOTE: Using `assert` bypasses needing to do a nil check before accessing a member
      --       that could be nil
      local Client = assert(vim.lsp.get_client_by_id(args.data.client_id))

      -- TODO: Take how lazyvim applies lsp method keymaps by giving it a
      --       'has' key to check it against a handler as well as a 'client_name'
      --       key for only enabling the key if it is that lsp client
      local keys = {
        { "K", vim.lsp.buf.hover, "Hover" },
        { "gK", vim.lsp.buf.signature_help, "Signature Helper" },
        { "<c-k>", vim.lsp.buf.signature_help, "Signature Helper", { "i" } },
        { "gd", Snacks.picker.lsp_definitions, "[G]oto [D]efinition" },
        { "grr", Snacks.picker.lsp_references, "[G]oto [R]eferences" },
        { "<leader>ds", Snacks.picker.lsp_symbols, "[D]ocument [S]ymbols" },
        { "<leader>ws", Snacks.picker.lsp_workspace_symbols, "[W]orkspace [S]ymbols" },
        { "gD", Snacks.picker.lsp_declarations, "[G]oto [D]eclaration" },
        { "gy", Snacks.picker.lsp_type_definitions, "Goto T[y]pe Definition" },
        { "<leader>cc", vim.lsp.codelens.run, "Run Codelens" },
        { "<leader>cC", vim.lsp.codelens.refresh, "Refresh & Display Codelens" },
      }

      if Client.server_capabilities.implementationProvider then
        table.insert(keys, { "gI", Snacks.picker.lsp_implementations, "[G]oto [I]mplementation" })
      end

      if Client.server_capabilities.colorProvider then
        vim.lsp.document_color.enable(true, args.buf, {
          style = 'virtual'
        })
      end

      -- if Client.server_capabilities.codeLensProvider then
      --   vim.lsp.codelens.refresh()
      -- end

      if Client.name == "vtsls" then
        Client.settings.javascript = Client.settings.typescript
      end

      -- Setup any LSP Client keymaps and server capabalities
      if vim.tbl_contains(config_keys, Client.name) then
        local ok, client = pcall(require, "modules.lsp.client." .. Client.name)
        if ok then
          client.setup(Client, keys)
        end
      end

      -- setup any lsp ClientToServer method functionality and/or keymaps
      for _, method in pairs(vim.lsp.protocol.Methods) do
        -- Prints out all capabilities
        -- vim.print(method)
        if Client:supports_method(method, args.buf) and client_methods[method] then
          client_methods[method](args.buf, keys, Client)
        end
      end

      -- vim.lsp.set_log_level("debug")

      lsp_autocmds.setup(Client, args.buf)
      make_keymaps(args.buf, keys)

      vim.diagnostic.config {
        severity_sort = true,
        underline = { severity = { vim.diagnostic.severity.ERROR, vim.diagnostic.severity.WARN } },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = Helpers.ui.icons.diagnostics.Error,
            [vim.diagnostic.severity.WARN] = Helpers.ui.icons.diagnostics.Warn,
            [vim.diagnostic.severity.INFO] = Helpers.ui.icons.diagnostics.Info,
            [vim.diagnostic.severity.HINT] = Helpers.ui.icons.diagnostics.Hint,
          },
        },
        float = { border = "rounded", source = "if_many", format = Helpers.formatting.formatErrors },
        virtual_text = {
          spacing = 2,
          source = "if_many",
          prefix = "●",
          severity = {
            min = vim.diagnostic.severity.WARN,
          },
        },
      }
    end,
  })
end

return M
