local api = vim.api
local autocmd = api.nvim_create_autocmd
local augroup = api.nvim_create_augroup
local utils   = require("configurations.lsp.utils")

local function lsp_attach()
  local lsp_group = augroup("barnt/lsp_attach", { clear = true })
  autocmd("LspAttach", {
    group = lsp_group,
    callback = function(ev)
      local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))

      -- Remove default keybinds
      for _, bind in ipairs { "grn", "gra", "gri", "grr", "grt", "K" } do
        pcall(vim.keymap.del, "n", bind, { buffer = ev.buf })
      end

      -- Setup our server capabilities
      utils.setup_server_capabilities(client, ev.buf)
      Utils.keymaps.make_buffer_only(Config.keys.lsp, ev.buf)
    end,
  })
end

---@param name string
---@return vim.lsp.Config
function get_config(name)
  local ok, ret = pcall(require, "configurations.lsp.servers." .. name)
  if ok then
    return ret
  else 
    return {}
  end
end

---@class config.lsp
---@field debuggers        string[]
---@field formatters       string[]
---@field language_servers table<string, string>
---@field linters          string[]
local M = {}

--stylua: ignore start
M.debuggers = {}

M.formatters = {
  "clang-format", "gofumpt", "goimports",
  "gomodifytags", "shfmt", "stylua",
  "xmlformatter",
}

M.language_servers = {
  ["clangd"] = "clangd",
  ["cmake-language-server"] = "cmake",
  ["css-lsp"] = "cssls",
  ["css-variables-language-server"] = "css_variables",
  ["cssmodules-language-server"] = "cssmodules_ls",
  ["emmet-ls"] = "emmet_ls",
  ["gopls"] = "gopls",
  ["html-lsp"] = "html",
  ["intelephense"] = "intelephense",
  ["json-lsp"] = "jsonls",
  ["just-lsp"] = "just",
  ["lemminx"] = "lemminx",
  ["lua-language-server"] = "lua_ls",
  ["nushell"] = "nushell",
  ["powershell-editor-services"] = "powershell_es",
  ["pyrefly"] = "pyrefly",
  ["roslyn"] = "roslyn_ls",
  ["ruff"] = "ruff",
  ["svelte-language-server"] = "svelte",
  ["tailwindcss-language-server"] = "tailwindcss",
  ["taplo"] = "taplo",
  ["vim-language-server"] = "vimls",
  ["vtsls"] = "vtsls",
  ["yaml-language-server"] = "yamlls",
}

M.linters = { "cmakelint", "shellcheck" }

-- stylua: ignore end

--- Setup language servers
M.setup = function()
  --- Blanket apply capabilities to all LSPs
  vim.lsp.config("*", {
    capabilities = utils.create_capabilities(),
  })

  --- Setup and enable the language servers I am using
  for _, lsp in ipairs(vim.tbl_values(Config.lsp.language_servers)) do
    ---@type vim.lsp.Config
    local merged_config = vim.tbl_deep_extend("force", vim.lsp.config[lsp], get_config(lsp))
    vim.lsp.config[lsp] = merged_config
    vim.lsp.enable(lsp)
  end

  local completion_kinds = vim.lsp.protocol.CompletionItemKind
  local icons = Config.ui.icons.kinds
  for i, kind in ipairs(completion_kinds) do
    completion_kinds[i] = icons[kind] and icons[kind] .. kind or kind
  end

  vim.diagnostic.config(Config.diagnostics.config)
  lsp_attach()
end

--- Creates a flattened arrary of all Mason servers to download
function M:ensure_installed()
  local lsps = vim.tbl_keys(self.language_servers)
  return vim.iter({
    lsps,
    self.debuggers,
    self.formatters,
    self.linters 
  }):flatten(math.huge):totable()
end

return M
