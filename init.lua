-- TODO: Move Keymap and configs back to lua/plugins/<plugin>.lua
--       but I would like to keep the keymaps as a separate table
--       also create a which-key register in that plugin file

-- TODO: Add total characters selected with cursor to statusbar when visually selecting string

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

-- Support only Neovim v0.12 and nightly
if vim.fn.has("nvim-0.12") ~= 1 then
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Must be using at least Neovim v0.12 to use:\n", "ErrorMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

-- Set some global variables immediently

vim.g.nushell = vim.fn.executable "nu"
vim.g.debug = false

-- Bootstrap lazy.nvim we need to make sure any thing plugin releated is
-- loaded and available for the rest of our configuration startup
require("lazy-bootstrap")
