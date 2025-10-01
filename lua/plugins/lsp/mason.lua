return {
  "mason-org/mason.nvim",
  keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
  cmd = "Mason",
  build = ":MasonUpdate",
  opts_extend = { "ensure_installed" },
  opts = {
      registries = { "github:mason-org/mason-registry", "github:crashdummyy/mason-registry" },
      -- NOTE: [mason.nvim] does not have an ensured installed key, I am adding it into the plugin spec
      --       because I'm using it
      ensure_installed = require("helpers").build_table(
        Installables.servers,
        Installables.formatters,
        Installables.linters,
        Installables.dap
      ),
  },
  config = function(_, opts)
    require("mason").setup(opts)

    local mr = require "mason-registry"
    mr:on("package:install:success", function()
      vim.defer_fn(function()
        require("lazy.core.handler.event").trigger {
          event = "FileType",
          buf = vim.api.nvim_get_current_buf(),
        }
      end, 100)
    end)

    -- Install all ensure_installed packages get installed if they are not currently installed
    mr.refresh(function()
      for _, tool in ipairs(opts.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          -- https://github.com/williamboman/mason-lspconfig.nvim/blob/1a31f824b9cd5bc6f342fc29e9a53b60d74af245/lua/mason-lspconfig/install.lua#L12
          p:install()
        end
      end
    end)
  end,
}
