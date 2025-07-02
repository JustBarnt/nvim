if vim.fn.has "nvim-0.12" ~= 1 then
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Must be using at least Neovim nightly to use:\n", "ErrorMsg" },
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
    ctx = "ctx"
  },
  pattern = {
    [".*/git/%a+(%-?%a+)"] = { "gitconfig", { priority = 10 } },
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
