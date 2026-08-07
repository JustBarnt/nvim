-- Registrer Utils
_G.Utils = require("utils")

-- [[
--  Load in the following order
--  1. User Defined
--    1. Options
--  2. Plugins
--    1. theme
--    2. treesitter
--    3. lspconfig
--    4. dap
--    5. everything else
--  3. Autocmds
--  4. Commands
--  5. Keymaps

-- ]]

-- [[
-- Folder structure
-- 
-- lua/
--  user/
--    options.lua
--    autocmds.lua
--    commands.lua
--    keymaps.lua
--    nushell.lua
--  plugins/
--    theme.lua
--    treesitter.lua
--    coding.lua     (coding related)
--    lsp.lua        (dap, lsp, blink, formatting)
--    editor.lua     (editor based plugins)
--    ui.lua         (ui related plugins)
--  utils/
-- ]]

-- Setup our user options
require("user.options")

-- We want to setup our plugins in a very specific order
require("plugins/themes")
require("plugins/treesitter")
require("plugins/coding")
require("plugins/lsp")
require("plugins/editor")
require("plugins/ui")
