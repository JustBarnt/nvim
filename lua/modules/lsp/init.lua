local M = {}
local api = vim.api
local client_methods = require("modules.lsp.client_capabilities")
local lspgroup = api.nvim_create_augroup("lsp", {})

local function setup_lsp_hover()
  local hover = vim.lsp.buf.hover
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.lsp.buf.hover = function(config)
    config = config or {}
    config.border = "rounded"
    hover(config)
  end

  local signature_help = vim.lsp.buf.signature_help
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.lsp.buf.signature_help = function(config)
    config = config or {}
    config.border = "rounded"
    signature_help(config)
  end
end

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
  local lsp_commands = require("modules.lsp.user-commands").setup

  for _, v in ipairs(vim.api.nvim_get_runtime_file("lsp/*", true)) do
    local name = vim.fn.fnamemodify(v, ":t:r")
    configs[name] = true
  end

  config_keys = vim.tbl_keys(configs)
  vim.lsp.enable(config_keys)

  setup_lsp_hover()

  local keys = {
    { "K", vim.lsp.buf.hover, "Hover" },
    { "gK", vim.lsp.buf.signature_help, "Signature Helper" },
    { "<c-k>", vim.lsp.buf.signature_help, "Signature Helper", { "i" } },
    { "gd", Snacks.picker.lsp_definitions, "[G]oto [D]efinition" },
    { "gr", Snacks.picker.lsp_references, "[G]oto [R]eferences" },
    { "<leader>ds", Snacks.picker.lsp_symbols, "[D]ocument [S]ymbols" },
    { "<leader>ws", Snacks.picker.lsp_workspace_symbols, "[W]orkspace [S]ymbols" },
    { "gD", Snacks.picker.lsp_declarations, "[G]oto [D]eclaration" },
    { "gy", Snacks.picker.lsp_type_definitions, "Goto T[y]pe Definition" },
  }

  lsp_commands()

  api.nvim_create_autocmd("LspAttach", {
    group = lspgroup,
    callback = function(args)
      -- NOTE: Using `assert` bypasses needing to do a nil check before accessing a member
      --       that could be nil
      local Client = assert(vim.lsp.get_client_by_id(args.data.client_id))

      if Client.server_capabilities.implementationProvider then
        table.insert(keys, { "gI", Snacks.picker.lsp_implementations, "[G]oto [I]mplementation" })
      end

      vim.keymap.set("n", "<leader>mlr", function()
        vim.ui.input({ prompt = "LSP Request Method: " }, function(input)
          local param = { textDocument = vim.lsp.util.make_text_document_params(args.buf) }
          vim.lsp.buf_request_all(0, input, param, function(results, ctx)
            vim.print("---------Request Results---------")
            vim.print(results)
            vim.print("---------Request Context---------")
            vim.print(ctx)
          end)
        end)
      end, { desc = "Make an LSP Request" })

      if Client:supports_method("textDocument/documentColor", args.buf) then
        Client.server_capabilities.colorProvider = vim.empty_dict()
        vim.lsp.document_color.enable(true, args.buf)
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
          client_methods[method](args.buf, keys)
        end
      end

      -- vim.lsp.set_log_level("debug")

      make_keymaps(args.buf, keys)
    end,
  })
end

return M
