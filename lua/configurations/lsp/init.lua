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
      -- utils.setup_client_methods(client, ev.buf)
      Utils.keymaps.make_buffer_only(Config.keys.lsp, ev.buf)
    end,
  })
end

local function lsp_progress()
  ---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
  local progress = vim.defaulttable()
  autocmd("LspProgress", {
    ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin"|"report"|"end"}]]
      if not client or type(value) ~= "table" then
        return
      end
      local p = progress[client.id]

      for i = 1, #p + 1 do
        if i == #p + 1 or p[i].token == ev.data.params.token then
          p[i] = {
            token = ev.data.params.token,
            msg = ("[%3d%%] %s%s"):format(
              vim.kind == "end" and 100 or value.percentage or 100,
              value.title or "",
              value.message and (" **%s**"):format(value.message) or ""
            ),
            done = value.kind == "end"
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
            or spinner[math.floor(vim.uv.hrtime() /(1e6 * 80)) % #spinner + 1]
        end
      })
    end
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
  ["emmet-language-server"] = "emmet_language_server",
  ["gopls"] = "gopls",
  ["html-lsp"] = "html",
  ["intelephense"] = "intelephense",
  ["json-lsp"] = "jsonls",
  ["just-lsp"] = "just",
  ["laravel_ls"] = "laravel_ls",
  ["lemminx"] = "lemminx",
  ["lua-language-server"] = "lua_ls",
  ["nushell"] = "nushell",
  ["powershell-editor-services"] = "powershell_es",
  ["pyrefly"] = "pyrefly",
  ["roslyn"] = "roslyn_ls",
  ["ruff"] = "ruff",
  ["sqls"] = "sqls",
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
  lsp_progress()
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
