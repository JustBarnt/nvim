local M = {}
local api = vim.api
local lsp_methods = vim.lsp.protocol.Methods
local client_methods = require("modules.lsp.client_capabilities")
local lspgroup = api.nvim_create_augroup("lsp", {})

local function setup_lsp_hover()
  -- local hover = vim.lsp.buf.hover
  ---@param config vim.lsp.buf.hover.Opts
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.lsp.buf.hover = function(config)
    config = config or {}
    config.border = "rounded"

    local Client = vim.lsp.get_clients({ bufnr = 0 })[1]
    local params = vim.lsp.util.make_position_params(0, Client.offset_encoding)
    assert(Client)

    vim.lsp.buf_request(0, "textDocument/hover", params, function(err, res, ctx)
      if err then
        vim.notify("Hover error" .. vim.inspect(err))
      end

      if res == nil then
        if Client.name == "prismals" then
          vim.print({
            context = {
              client_id = ctx.client_id,
              bufnr = ctx.bufnr,
              method = ctx.method,
              params = ctx.params,
              version = ctx.version,
            },
            result = res,
          })
        end
      else
        vim.notify("FOUND")
        local md = vim.lsp.util.convert_input_to_markdown_lines(res.contents)
        vim.lsp.util.open_floating_preview(md, "markdown", config)
      end
    end)
    -- hover(config)
  end

  ---@param res lsp.LSPAny|nil
  vim.lsp.handlers["textDocument/hover"] = function(err, res, ctx, config)
    local Client = vim.lsp.get_client_by_id(ctx.client_id)
    assert(Client)
    if err then
      vim.notify("Hover error" .. vim.inspect(err))
    end

    if res == nil then
      if Client.name == "prismals" then
        vim.print({
          context = {
            client_id = ctx.client_id,
            bufnr = ctx.bufnr,
            method = ctx.method,
            params = ctx.params,
            version = ctx.version,
          },
          result = res,
        })
      end
    else
      vim.notify("FOUND")
      local md = vim.lsp.util.convert_input_to_markdown_lines(res.contents)
      vim.lsp.util.open_floating_preview(md, "markdown", config)
    end
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
  dofile(vim.g.base46_cache .. "lsp")
  dofile(vim.g.base46_cache .. "codeactionmenu")

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

      -- vim.lsp.handlers["client/registerCapability"] = function(err, result, ctx)
      --   local client = vim.lsp.get_client_by_id(ctx.client_id)
      --   if client and result and result.registrations then
      --     vim.print(result)
      --     for _, reg in ipairs(result.registrations) do
      --       if reg.method == "textDocument/formatting" then
      --         vim.notify("LEMMINX DYNAMICALLY REGISTERS FORMATTING")
      --         client.server_capabilities.documentFormattingProvider = true
      --       end
      --     end
      --   end
      --   return result
      -- end

      --TODO: Setup code to allow for Dynamic Server Capabilities registration to be defauted instead of forcing it statically like
      --      I am currently doing the lemmix LSP and formatting. I want to be able to check my result.registration.methods and call
      --      my client_methods file like I do below for static capabalities

      -- Some LSP clients I have noticed support formatting, but the documentFormattingProvider is set to false,
      -- setting it to true if client does indeed support it allows keymaps like my formatting to be added when the client actually does support it
      -- if Client:supports_method("textDocument/formatting", 0) then
      --   Client.server_capabilities.documentFormattingProvider = true
      -- end

      -- Setup any LSP Client keymaps and server capabalities
      if vim.tbl_contains(config_keys, Client.name) then
        local ok, client = pcall(require, "modules.lsp.client." .. Client.name)
        if ok then
          client.setup(Client, keys)
        end
      end

      -- stylua: ignore
      vim.lsp.get_client_by_id(1):request("textDocument/hover", vim.lsp.util.make_position_params(vim.api.nvim_get_current_win(), 'utf-16'), function(err, res, ctx) vim.print() end, vim.api.nvim_get_current_buf())
      -- styllua: ignore
      -- vim.lsp.buf_request_all(0, "textDocument/hover", vim.lsp.util.make_position_params(vim.api.nvim_get_current_win(), 'utf-16' ), function(results, ctx) vim.print(results) end)
      -- stylua: ignore
      -- vim.lsp.buf_request_sync(0, "textDocument/hover", vim.lsp.util.make_position_params(vim.api.nvim_get_current_win(), 'utf-16' ))

      vim.lsp.set_log_level("debug")

      -- setup any lsp ClientToServer method functionality and/or keymaps
      for _, method in pairs(lsp_methods) do
        if Client:supports_method(method, args.buf) and client_methods[method] then
          client_methods[method](args.buf, keys)
        end
      end

      make_keymaps(args.buf, keys)
    end,
  })
end

return M
