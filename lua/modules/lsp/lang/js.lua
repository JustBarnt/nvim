---@class LspCommand: lsp.ExecuteCommandParams
---@field handler? lsp.Handler

---@param opts LspCommand
local function execute(opts)
  local params = {
    command = opts.command,
    arguments = opts.arguments,
  }

  return vim.lsp.buf_request(0, "workspace/executeCommand", params, opts.handler)
end

local action = setmetatable({}, {
  __index = function(_, action)
    return function()
      vim.lsp.buf.cod_action({
        apply = true,
        context = {
          only = { action },
          diagnostics = {},
        },
      })
    end
  end,
})

---@type LSPConfig
return {
  servers = { "vtsls" },
  treesitters = { "javascript", "typescript", "tsx" },
  formatters = { "biome" },
  formatter_options = { require_cwd = true },
  filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
  -- stylua: ignore
  keys = {
    {
      "gD",
      function()
        ---@diagnostic disable-next-line: missing-parameter
        local params = vim.lsp.util.make_position_params()
        execute({
          command = "typescript.goToSourceDefinition",
          arguments = { params.textDocument.uri, params.position },
        })
      end,
      desc = "Goto Source Definition"
    },
    {
      "gR",
      function()
        execute({
          command = "typescript.findAllFileReferences",
          arguments = { vim.uri_from_bufnr(0) },
        })
      end,
      desc = "File References",
    },
    { "<leader>co", action["source.organizeImports"], desc = "Organize Imports", },
    { "<leader>cM", action["source.addMissingImports.ts"], desc = "Add missing imports" },
    { "<leader>cu", action["source.removeUnused.ts"], desc = "Remove unused imports" },
    { "<leader>cD", action["source.fixAll.ts"], desc = "Fix all diagnostics" },
    {
      "<leader>cV",
      function()
        execute({ command = "typescript.selectTypeScriptVersion" })
      end,
      desc = "Select TS workspace version",
    },
  },
  settings = {
    complete_function_calls = true,
    vtsls = {
      enableMoveToFileCodeAction = true,
      autoUseWorkspaceTsdk = true,
      experimental = {
        maxInlayHintLength = 30,
        completion = {
          enableServerSideFuzzyMatch = true,
        },
      },
    },
    javascript = {
      updateImportsOnFileMove = { enabled = "always" },
      suggest = {
        completeFunctionCalls = true,
      },
      inlayHints = {
        enumMemberValues = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        parameterNames = { enabled = "literals" },
        parameterTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        variableTypes = { enabled = false },
      },
    },
    typescript = {
      updateImportsOnFileMove = { enabled = "always" },
      suggest = {
        completeFunctionCalls = true,
      },
      inlayHints = {
        enumMemberValues = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        parameterNames = { enabled = "literals" },
        parameterTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        variableTypes = { enabled = false },
      },
    },
  },
}
