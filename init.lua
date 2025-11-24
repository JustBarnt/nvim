 _G.dd = function(...)
   require("snacks.debug").inspect(...)
 end

_G.bt = function(...)
  require("snacks.debug").backtrace()
end

vim.print = dd

-- Leader keys
-- vim.keycode translates keycodes instead of strings
vim.g.mapleader = vim.keycode("<space>")
vim.g.maplocalleader = vim.keycode("\\")

-- Support only Neovim v0.11 and nightly
if vim.fn.has("nvim-0.11") ~= 1 then
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Must be using at least Neovim v0.11 to use:\n", "ErrorMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.g.nushell = vim.fn.executable "nu"

-- Bootstrap lazy.nvim we need to make sure any thing plugin releated is
-- loaded and available for the rest of our configuration startup
require("lazy-bootstrap")
