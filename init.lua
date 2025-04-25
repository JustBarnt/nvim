if vim.fn.has("nvim-0.11") ~= 1 then
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Must be using at least Neovim V0.11 or nightly to use:\n", "ErrorMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

-- Add filetypes for nushell if the executable is found
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

---@diagnostic disable-next-line: undefined-global
if init_debug then
  local osvpath = vim.fn.stdpath("data") .. "/lazy/one-small-step-for-vimkind"
  vim.opt.rtp:append(osvpath)
  require("osv").launch({ port = 8086, blocking = true })
end

require("core.options")
require("core.lazy")

--- FROM LUA_LS
-- Colors request
local lua_ls_request = {
  position = { character = 10, line = 35 },
  textDocument = { uri = "file:///D:/Personal/nvim-plugins/nordic.nvim/lua/nordic/colors/nordic.lua" },
}
-- RPC Send
local lua_ls_send = {
  id = 11,
  jsonrpc = "2.0",
  method = "textDocument/documentColor",
  params = {
    position = { character = 10, line = 35 },
    textDocument = { uri = "file:///D:/Personal/nvim-plugins/nordic.nvim/lua/nordic/colors/nordic.lua" },
  },
}
-- RPC Recieve
local lua_ls_received = { id = 11, jsonrpc = "2.0", result = {} }

--- FROM CSSLS
local cssls_request = {
  range = { ["end"] = { character = 0, line = 93 }, start = { character = 0, line = 0 } },
  textDocument = { uri = "file:///D:/CommSys/Utilities/License-Tool/WebUI/src/app.css" },
}
local cssls_send = {
  id = 7,
  jsonrpc = "2.0",
  method = "textDocument/documentColor",
  params = {
    range = { ["end"] = { character = 0, line = 93 }, start = { character = 0, line = 0 } },
    textDocument = { uri = "file:///D:/CommSys/Utilities/License-Tool/WebUI/src/app.css" },
  },
}
local cssls_recieve = {
  id = 7,
  jsonrpc = "2.0",
  result = {
    {
      color = { alpha = 0.75, blue = 1, green = 1, red = 1 },
      range = { ["end"] = { character = 46, line = 81 }, start = { character = 21, line = 81 } },
    },
    {
      color = { alpha = 0.05, blue = 0, green = 0, red = 0 },
      range = { ["end"] = { character = 66, line = 81 }, start = { character = 47, line = 81 } },
    },
  },
}
