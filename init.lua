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

vim.filetype.add {
  extension = {
    nu = "nu",
    nush = "nu",
    nuon = "nu",
    nushell = "nu",
    log = "log",
    xaml = "xaml",
    axaml = "axaml",
  },
  pattern = {
    [".*/git/%a+(%-?%a+)"] = { "gitconfig", { priority = 10 }},
  },
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
