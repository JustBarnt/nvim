---@class utils.dap
local M = {}

local dap = require("dap")

---@param name string dap adapter name
local function get_adapter_root(name)
  return require("mason-core.installer.InstallLocation").global():package(name)
end

function M.init()
  dap.adapters.php = {
    type = "executable",
    command = "php-debug-adapter",
    args = {}
  }

  dap.configurations.php = {
    {
      type = "php",
      request = "launch",
      name = "listen for xdebug",
      port = 9003,
      -- pathMappings = {
      --   ["/var/www/html"] = "${workspaceFolder}",
      -- },
    },
  }
end

return M
