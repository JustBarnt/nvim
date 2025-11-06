-- Support only Neovim v0.11 and nightly
if vim.fn.has "nvim-0.11" ~= 1 then
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Must be using at least Neovim v0.11 to use:\n", "ErrorMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

-- Load our filetype additions
require("filetypes").setup()

-- Bootstrap lazy.nvim we need to make sure any thing plugin releated is 
-- loaded and available for the rest of our configuration startup
require "lazy"

-- Load the our user modules
require "user.options"
require "user.keymaps"

-- Load neovide settings if we are in neovide
if vim.g.neovide then
  require "user.neovide"
end
