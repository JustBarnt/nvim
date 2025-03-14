local utils = require("utils")

return {
	{
		"williamboman/mason.nvim",
    event = "BufEnter",
    cmd = "Mason",
    keys = { { "<leader>cm", "<CMD>Mason<CR>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = function(_, opts)
      local servers = utils.get_ensured_installed("lua/module/lsp/lang", "servers")
      local formatters = utils.get_ensured_installed("lua/module/lsp/lang", "formatters")
      return {
        registries = { "github:mason-org/mason-registry", "github:crashdummyy/mason-registry" },
        ensure_installed = utils.build_table(opts.ensure_installed, servers, formatters)
      }
    end,
    config = function(_, opts)
      local InstallationHandle = require("mason-core.installer.handle")
      require("mason").setup(opts)

      local mr = require("mason-registry")
      mr:on("package:install", function(payload)
        local state = payload._value.state
        ---@type Package
        local pkg = payload._value.package
        if state == "ACTIVE" then
          vim.defer_fn(function()
            mr:emit("package:install", pkg:get_handle())
          end, 1000)
        elseif state == "CLOSED" then
          vim.notify(string.format("%s is installed: %s", pkg.name, pkg:is_installed()), vim.log.levels.INFO)
        end
      end)


      mr:on("package:install:success", function()
        vim.defer_fn(function()
          -- Reload the file to start the lsp after it was installed
          vim.cmd("edit " .. vim.fn.expand("%:p"))
        end, 100)
      end)

      -- Install all ensure_installed packages if they are not currently installed
      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
            mr:emit("package:install", p:get_handle())
          end
        end
      end)
    end,
	},
}
