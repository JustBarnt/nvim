return {
  {
    "mason-org/mason.nvim",
    event = "VeryLazy",
    build = ":MasonUpdate",
    opts = {
      ui = {
        icons = {
          package_installed   = Config.ui.icons.misc.package.installed,
          package_pending     = Config.ui.icons.misc.dots,
          package_uninstalled = Config.ui.icons.misc.package.uninstalled,
        },
      },
      registries = { "github:mason-org/mason-registry", "github:crashdummyy/mason-registry" },
    },
    init = function()
      local mr = require("mason-registry")

      ---https://github.com/LazyVim/LazyVim/blob/c64a61734fc9d45470a72603395c02137802bc6f/lua/lazyvim/plugins/lsp/init.lua#L283
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)

      mr.refresh(function()
        for _, tool in ipairs(Config.lsp:ensure_installed()) do
          if tool == "rust-analyzer" then
            goto continue
          end
          local ok, p = pcall(mr.get_package, tool)
          if ok then
            if not p:is_installed() then
              p:install()
            end
          end
          ::continue::
        end
      end)
    end
  }
}
