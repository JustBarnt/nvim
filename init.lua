if vim.g.vscode then
    return
end

-- Support only Neovim v0.12 and nightly
if vim.fn.has("nvim-0.13") ~= 1 then
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Must be using at least Neovim v0.13 to use:\n", "ErrorMsg" },
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
require("bootstrap")

if vim.g.neovide then
   require "user.neovide"
end
