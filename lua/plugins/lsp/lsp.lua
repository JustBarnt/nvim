---@module "conform"

return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<CMD>Mason<CR>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = function()
      local server = require("modules.lsp.lang").get_option("servers")
      return {
        registries = { "github:mason-org/mason-registry", "github:crashdummyy/mason-registry" },
        -- NOTE: [mason.nvim] does not have an ensured installed key, I am adding it into the plugin spec
        --       because I'm using it
        ensure_installed = require("helpers").build_table(server),
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
        formatters = {
          biome = {
            require_cwd = true,
          },
          xmlformat = {
            prepend_args = { "--selfclose", "--indent", "4", "--preserve", "literal" },
          },
        },
        formatters_by_ft = {
          xml = { "xmlformat" },
          json = { "biome" },
          jsonc = { "biome" },
          css = { "biome" },
          javascript = { "biome" },
          typescript = { "biome" },
          svelte = { "biome", "prettier" },
          html = { "biome", "prettier" },
          lua = { "stylua" },
          python = { "black" },
          go = { "goimports", "gofumpt" },
        },
      }
      return opts
    end,
    config = function(_, opts)
      require("conform").setup(opts)
    end,
  },
  {
    "Civitasv/cmake-tools.nvim",
    lazy = true,
    init = function()
      local loaded = false
      local function check()
        local cwd = vim.uv.cwd()
        if vim.fn.filereadable(cwd .. "/CMakeLists.txt") == 1 then
          require("lazy").load({ plugins = { "cmake-tools.nvim" } })
          loaded = true
        end
      end
      check()
      vim.api.nvim_create_autocmd("DirChanged", {
        callback = function()
          if not loaded then
            check()
          end
        end,
      })
    end,
    opts = {},
  },
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
    version = false, -- last release is very old, so we just use the latest commits
  },
}
