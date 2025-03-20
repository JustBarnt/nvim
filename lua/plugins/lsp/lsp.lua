local utils = require("helpers")

---@module "conform"

return {
  {
    "williamboman/mason.nvim",
    event = "BufEnter",
    cmd = "Mason",
    keys = { { "<leader>cm", "<CMD>Mason<CR>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = function(_, opts)
      local servers = utils.get_ensured_installed("lua/modules/lsp/lang", "servers")
      local formatters = utils.get_ensured_installed("lua/modules/lsp/lang", "formatters")
      return {
        registries = { "github:mason-org/mason-registry", "github:crashdummyy/mason-registry" },
        -- NOTE: [mason.nvim] does not have an ensured installed key, I am adding it into the plugin spec
        --       because I'm using it
        ensure_installed = utils.build_table(opts.ensure_installed, servers, formatters),
      }
    end,
    config = function(_, opts)
      require("mason").setup(opts)

      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)

      -- Install all ensure_installed packages get installed if they are not currently installed
      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            -- https://github.com/williamboman/mason-lspconfig.nvim/blob/1a31f824b9cd5bc6f342fc29e9a53b60d74af245/lua/mason-lspconfig/install.lua#L12
            p:install():once(
              "closed",
              vim.schedule_wrap(function()
                if p:is_installed() then
                  vim.notify(("[mason.nvim] %s was installed successfully"):format(p.name))
                else
                  vim.notify(
                    ("[mason.nvim] failed to install %s. Installation logs are available in :Mason and :MasonLog"):format(
                      p.name
                    ),
                    vim.log.levels.ERROR
                  )
                end
              end)
            )
          end
        end
      end)
    end,
  },
  {
    "stevearc/conform.nvim",
    dependencies = { "mason.nvim" },
    lazy = true,
    cmd = "ConformInfo",
    opts = function()
      ---@type conform.setupOpts
      local opts = {
        default_format_opts = {
          timeout_ms = 3000,
          async = false,
          quiet = false,
          lsp_format = "fallback",
        },
        formatters_by_ft = vim.iter(ConfiguredLangs):fold(
          {},
          ---@param acc table
          ---@param lang string
          ---@param config LSPConfig
          function(acc, lang, config)
            acc[lang] = config.formatters_by_ft
            return acc
          end
        ),
      }
      return opts
    end,
    config = function(_, opts)
      require("conform").setup(opts)
    end,
  },
}
