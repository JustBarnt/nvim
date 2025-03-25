---@class modules.lsp.lang.cpp
---@overload fun(config: vim.lsp.Config): vim.lsp.Config
local M = setmetatable({}, {
  __call = function(m, ...)
    return m.make_config(...)
  end,
})

M["cpp"] = {
  servers = { "clangd" },
  treesitters = { "cpp", "c" },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
  keys = {
    { "<leader>ch", "<CMD>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
  },
}

-- https://clangd.llvm.org/extensions.html#switch-between-sourceheader
local function switch_source_header(bufnr)
  local method_name = "textDocument/switchSourceHeader"
  bufnr = vim.validate("bufnr", bufnr, "number")
  local client = vim.lsp.get_clients({ bufnr = bufnr })[1]

  if not client then
    return vim.notify(("method %s is not supported by any servers active on the current buffer"):format(method_name))
  end

  local params = vim.lsp.util.make_text_document_params(bufnr)
  client:request(method_name, params, function(err, result)
    if err then
      error(tostring(err))
    end
    if not result then
      vim.notify("corresponding file cannot be determined")
      return
    end
    vim.cmd.edit(vim.uri_to_fname(result))
  end, bufnr)
end

local function symbol_info()
  local bufnr = vim.api.nvim_get_current_buf()
  local clangd_client = vim.lsp.get_clients({ bufnr = bufnr })[1]
  if not clangd_client or not clangd_client:supports_method("textDocument/symbolInfo") then
    return vim.notify("Clangd client not found", vim.log.levels.ERROR)
  end
  local win = vim.api.nvim_get_current_win()
  local params = vim.lsp.util.make_position_params(win, clangd_client.offset_encoding)
  clangd_client:request("textDocument/symbolInfo", params, function(err, res)
    if err or #res == 0 then
      -- Clangd always returns an error, there is not reason to parse it
      return
    end
    local container = string.format("container: %s", res[1].containerName) ---@type string
    local name = string.format("name: %s", res[1].name) ---@type string
    vim.lsp.util.open_floating_preview({ name, container }, "", {
      height = 2,
      width = math.max(string.len(name), string.len(container)),
      focusable = false,
      focus = false,
      border = "single",
      title = "Symbol Info",
    })
  end, bufnr)
end

local Config = {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--fallback-style=llvm",
  },
  root_markers = {
    ".git",
    ".clangd",
    ".clangd-tidy",
    ".clang-format",
    "compile_commands.json",
    "compile_flags.txt",
    "configure.ac",
  },
  filetypes = M.cpp.filetypes,
  capabilities = Helpers.lsp.create_capabilities({
    textDocument = {
      completion = {
        editsNearCursor = true,
      },
    },
  }),
  commands = {
    ClangdSwitchSourceHeader = function()
      switch_source_header(0)
    end,
    ClangdShowSymbolInfo = function()
      symbol_info()
    end,
  },
  init_options = {
    usePlaceholders = true,
    completeUnimported = true,
    clandgFileStatus = true,
  },
  offsetEncoding = { "utf-8", "utf-16" },
  on_init = function(client)
    Helpers.lsp.on_init(client, M.cpp.settings)
  end,
}

---@param config vim.lsp.Config
function M.make_config(config)
  return LazyVim.merge({}, Config, config)
end

return M
