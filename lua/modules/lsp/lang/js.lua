---@class modules.lsp.lang.js
---@overload fun(config: vim.lsp.Config): vim.lsp.Config
local M = setmetatable({}, {
  __call = function(m, ...)
    return m.make_config(...)
  end,
})

M["js"] = {
  servers = { "vtsls", "biome" },
  treesitters = { "javascript", "typescript", "tsx", "jsdoc" },
  filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
  -- stylua: ignore
  keys = {
    {
      "gD",
      function()
        ---@diagnostic disable-next-line: missing-parameter
        local params = vim.lsp.util.make_position_params()
        Helpers.lsp.execute({
          command = "typescript.goToSourceDefinition",
          arguments = { params.textDocument.uri, params.position },
        })
      end,
      desc = "Goto Source Definition"
    },
    {
      "gR",
      function()
        Helpers.lsp.execute({
          command = "typescript.findAllFileReferences",
          arguments = { vim.uri_from_bufnr(0) },
        })
      end,
      desc = "File References",
    },
    { "<leader>co", Helpers.lsp.action["source.organizeImports"], desc = "Organize Imports", },
    { "<leader>cM", Helpers.lsp.action["source.addMissingImports.ts"], desc = "Add missing imports" },
    { "<leader>cu", Helpers.lsp.action["source.removeUnused.ts"], desc = "Remove unused imports" },
    { "<leader>cD", Helpers.lsp.action["source.fixAll.ts"], desc = "Fix all diagnostics" },
    {
      "<leader>cV",
      function()
        Helpers.lsp.execute({ command = "typescript.selectTypeScriptVersion" })
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
    tsserver = {
      globalPlugins = {
        {
          name = "typescript-svelte-plugin",
          location = Helpers.get_pkg_path("svelte-language-server", "/node_modules/typescript-svelte-plugin"),
          enableForWorkspaceTypeVersion = true,
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

local Config = {
  cmd = { "vtsls", "--stdio" },
  root_markers = { ".git", "package.json", "tsconfig.json", "jsconfig.json" },
  filetypes = M.js.filetypes,
  capabilities = Helpers.lsp.create_capabilities(),
  on_init = function(client)
    Helpers.lsp.on_init(client, M.js.settings)
  end,
}

---@param config vim.lsp.Config
---@return vim.lsp.Config
function M.make_config(config)
  return LazyVim.merge({}, Config, config)
end

return M
