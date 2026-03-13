---@class utils.dap
local M = {}

local dap = require("dap")

function M.init()
  dap.adapters.php = {
    type = "executable",
    command = "node",
    args = { vim.fn.stdpath("data") .. '/mason/packages/php-debug-adapter/extension/out/phpDebug.js' }
  }

  dap.configurations.php = {
    {
      name = "Listen for Xdebug",
      type = "php",
      request = "launch",
      port = 9003,
    },
  }
end

return M
