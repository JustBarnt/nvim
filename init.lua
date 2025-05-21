vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46_cache/"

if vim.fn.has "nvim-0.11" ~= 1 then
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
if vim.fn.executable "nu" == 1 then
  vim.filetype.add {
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
  }
end

vim.filetype.add {
  extension = { log = "log" },
}

---@diagnostic disable-next-line: undefined-global
if init_debug then
  local osvpath = vim.fn.stdpath "data" .. "/lazy/one-small-step-for-vimkind"
  vim.opt.rtp:append(osvpath)
  require("osv").launch { port = 8086, blocking = true }
end

require "lsp_overrides"
require "core.options"
require "core.lazy"

for _, v in ipairs(vim.fn.readdir(vim.g.base46_cache)) do
  dofile(vim.g.base46_cache .. v)
end
