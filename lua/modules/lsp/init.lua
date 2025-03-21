local M = {}
local lsp = vim.lsp
local api = vim.api
local lsp_methods = vim.lsp.protocol.Methods
local client_methods = require("modules.lsp.client_capabilities")

-- a wrapper around client:supports_method for LSP capabilities
---@param client vim.lsp.Client
---@param method vim.lsp.protocol.Method
---@param bufnr? integer Some LSP's support methods in specific files
---@return boolean
local function client_supports_method(client, method, bufnr)
  return client:supports_method(method, bufnr)
end

---@param config vim.lsp.ClientConfig
---@return vim.lsp.ClientConfig
function M.make_config(config)
  local blink = require("blink-cmp")
  local capabilities =
    vim.tbl_deep_extend("force", lsp.protocol.make_client_capabilities(), blink.get_lsp_capabilities(), {
      workspace = {
        fileOperations = {
          didRename = true,
          willRename = true,
        },
        didChangeWatchedFiles = {
          dynamicRegistration = true,
        },
      },
    })
  local defaults = {
    handlers = {},
    capabilities = capabilities,
    init_options = vim.empty_dict(),
    settings = vim.empty_dict(),
  }

  if config then
    return vim.tbl_deep_extend("force", defaults, config)
  else
    return defaults
  end
end

---@param config vim.lsp.Config
local function enable(name, config)
  if lsp.config then
    lsp.config(name, config)
    lsp.enable(name)
    return
  end
  local group = api.nvim_create_augroup("lsp-enable-" .. name, { clear = true })
  for _, ft in ipairs(config.filetypes) do
    api.nvim_creat_autocmd("FileType", {
      pattern = ft,
      group = group,
      callback = function(args)
        if config.root_markers then
          config = vim.deepcopy(config)
          config.root_dir = vim.fs.root(args.buf, config.root_markers)
        end
        vim.lsp.start(config, {
          bufnr = args.buf,
          reuse_client = config.reuse_client,
        })
      end,
    })
  end
end

function M.setup()
  enable("lua_ls", Lsps["lua_ls"])
  enable("gopls", Lsps["gopls"])
  enable("bashls", Lsps["bashls"])

  local hover = vim.lsp.buf.hover
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.lsp.buf.hover = function(config)
    config = config or {}
    config.border = "single"
    hover(config)
  end

  local signature_help = vim.lsp.buf.signature_help
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.lsp.buf.signature_help = function(config)
    config = config or {}
    config.border = "single"
    signature_help(config)
  end

  -- stylua: ignore
  local keys = {
    {"gd", function() Snacks.picker.lsp_definitions() end, "[G]oto [D]efinition" },
    {"gr", function() vim.lsp.buf.references({ includeDeclaration = false}) end, "[G]oto [R]eferences" },
    {"gI", function() Snacks.picker.lsp_implementations() end, "[G]oto [I]mplementation" },
    {"<leader>D", function() Snacks.picker.lsp_type_definitions() end, "Type [D]efinition" },
    {"<leader>ds", function() Snacks.picker.lsp_symbols() end, "[D]ocument [S]ymbols" },
    {"<leader>ws", function() Snacks.picker.lsp_workspace_symbols() end, "[W]orkspace [S]ymbols" },
    {"<leader>rn", function() Snacks.rename.rename_file() end, "[R]e[n]ame" },
    {"<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" } },
    {"gD", function() Snacks.picker.lsp_declarations() end, "[G]oto [D]eclaration" },
    {"<leader>cr", vim.lsp.buf.rename, "Rename Symbol" },
  }

  local lspgroup = api.nvim_create_augroup("lsp", {})
  require("modules.lsp.progress").setup(lspgroup)
  require("modules.lsp.user-commands").setup()

  api.nvim_create_autocmd("LspAttach", {
    group = lspgroup,
    callback = function(args)
      -- Attach generic LSP keymaps here
      local map = function(lhs, rhs, desc, mode)
        mode = mode or "n"
        -- stylua: ignore
        vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, desc = "LSP: " .. desc })
      end

      -- NOTE: Using `assert` bypasses needing to do a nil check before accessing a member
      --       that could be nil
      local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

      if client.server_capabilities.implementationProvider then
        table.insert(keys, { "gD", Snacks.picker.lsp_implementations, "[G]oto [I]mplementation" })
      end

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

      if client.name == "vtsls" then
        client.commands["_typescript.moveToFileRefactoring"] = function(command, ctx)
          ---@type string, string, lsp.Range
          local action, uri, range = unpack(command.arguments)

          local function move(newf)
            client:request("workspace/executeCommand", {
              command = command.command,
              arguments = { action, uri, range, newf },
            })
          end

          local fname = vim.uri_to_fname(uri)
          client:request("workspace/executeCommand", {
            command = "typescript.tsserverRequest",
            arguments = {
              "getMoveToRefactoringFileSuggestions",
              {
                file = fname,
                startLine = range.start.line + 1,
                startOffset = range.start.character + 1,
                endLine = range["end"].line + 1,
                endOffset = range["end"].character + 1,
              },
            },
          }, function(_, result)
            ---@type string[]
            local files = result.body.files
            table.insert(files, 1, "Enter new path...")
            vim.ui.select(files, {
              prompt = "Select move destination:",
              format_item = function(f)
                return vim.fn.fnamemodify(f, ":~:.")
              end,
            }, function(f)
              if f and f:find("^Enter new path") then
                vim.ui.input({
                  prompt = "Enter move destination:",
                  default = vim.fn.fnamemodify(fname, ":h") .. "/",
                  completion = "file",
                }, function(newf)
                  return newf and move(newf)
                end)
              elseif f then
                move(f)
              end
            end)
          end)
        end
      end

      for _, method in pairs(lsp_methods) do
        ---@diagnostic disable-next-line param-type-mismatch
        if client_supports_method(client, method, args.buf) and client_methods[method] then
          -- Sets up any configured LSP Protocol Methods
          client_methods[method](args)
        end
      end

      for _, key in ipairs(keys) do
        map(key[1], key[2], key[3], key[4] and key[4] or nil)
      end
    end,
  })
end

return M
