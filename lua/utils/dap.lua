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

  dap.adapters.codelldb = {
    type = "executable",
    command = vim.fn.stdpath("data") .. '/mason/bin/codelldb.cmd',
    detached = false
  }

  dap.configurations.cpp = {
    {
      name = "Launch file",
      type = "codelldb",
      request = "launch",
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. "/", 'file')
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false
    }
  }
  
end

return M
