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

---@param config vim.lsp.Config
local function enable(name, config)
  if lsp.config then
    lsp.config(name, config)
    lsp.enable(name)
    return
  end
end

if vim.fn.executable("nu") == 1 then
  vim.filetype.add({
    extension = {
      nu = "nu",
      nush = "nu",
      nuon = "nu",
      nushell = "nu",
    },
    pattern = {
      ["."] = {
        function(path, bufnr)
          local content = vim.filetype.getlines(bufnr, 1)
          if vim.fileytpe.matchregex(content, [[^#!/usr/bin/env nu]]) then
            return "nu"
          end
        end,
        priority = -math.huge,
      },
    },
  })
end

function M.setup()
  --TODO: Eventually move these calls out of here and into a after/ftdetect folder?
  enable("bashls", Lang.bash())
  enable("clangd", Lang.cpp())
  enable("cmake", Lang.cmake())
  enable("gopls", Lang.go())
  enable("intelephense", Lang.php())
  enable("lua_ls", Lang.lua())
  enable("nushell", Lang.nu())
  enable("svelte", Lang.svelte())
  enable("vtsls", Lang.js())
  enable("lemminx", Lang.xml())

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
    {"gd", vim.lsp.buf.definition, "[G]oto [D]efinition" },
    {"gr", function() vim.lsp.buf.references({ includeDeclaration = false}) end, "[G]oto [R]eferences" },
    {"gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation" },
    {"<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition" },
    {"<leader>ds", vim.lsp.buf.document_symbol, "[D]ocument [S]ymbols" },
    {"<leader>ws", vim.lsp.buf.workspace_symbol, "[W]orkspace [S]ymbols" },
    {"<leader>rn", function() Snacks.rename.rename_file() end, "[R]e[n]ame" },
    {"<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" } },
    {"gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration" },
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

      if client.name == "svelte" then
        table.insert(keys, { "<leader>co", Helpers.lsp.action["source.organizeImports"], "Organize Imports" })
        client.capabilities.workspace.didChangeWatchedFiles = { dynamicRegistration = true }
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

      ---Disable in favor of basedpyright
      if client.name == "ruff" then
        client.server_capabilities.hoverProvider = false
      end

      if client.name == "vtsls" then
        client.commands["_typescript.moveToFileRefactoring"] = function(command, ctx)
          ---@diagnostic disable: assign-type-mismatch
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
