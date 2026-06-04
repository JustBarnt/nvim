return {
  {
    "mason-org/mason.nvim",
    lazy = false,
    build = ":MasonUpdate",
    opts_extended = { "ensure_installed" },
    opts = {
      -- stylua: ignore start
      ensure_installed = {
        -- formatters
        "clang-format", "gofumpt", "goimports",
        "gomodifytags", "shfmt", "stylua",
        "xmlformatter",

        -- language servers
        "css-lsp", "css-variables-language-server",
        "cssmodules-language-server", "emmet-language-server", "gopls",
        "html-lsp", "intelephense", "json-lsp", "just-lsp", "kotlin-lsp",
        "laravel_ls", "lemminx", "lua-language-server", "nushell", "neocmakelsp",
        "powershell-editor-services", "pyrefly", "roslyn", "ruff",
        "rust-analyzer", "svelte-language-server", "tailwindcss-language-server", "taplo",
        "tsgo", "vim-language-server", "yaml-language-server",

        -- linters
        "cmakelint", "shellcheck"
      },
      -- stylua: ignore end
      ui = {
        icons = {
          package_installed = Utils.ui.icons.misc.package.installed,
          package_pending = Utils.ui.icons.misc.dots,
          package_uninstalled = Utils.ui.icons.misc.package.uninstalled,
        },
      },
      registries = { "github:mason-org/mason-registry", "github:crashdummyy/mason-registry" },
    },
    init = function(plugin)
      local mr = require("mason-registry")

      ---https://github.com/LazyVim/LazyVim/blob/c64a61734fc9d45470a72603395c02137802bc6f/lua/lazyvim/plugins/lsp/init.lua#L283
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          require("lazy.core.handler.event").trigger {
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          }
        end, 100)
      end)

      mr.refresh(function()
        for _, tool in ipairs(plugin.opts.ensure_installed) do
          if vim.tbl_contains({ "rust-analyzer", "nushell", "laravel_ls" }, tool) then
            goto continue
          end
          if tool == "roslyn" then
            local ok, p = pcall(mr.get_package, "roslyn-unstable")
            if ok and not p:is_installed() then
              p:install()
            end
          else
            local ok, p = pcall(mr.get_package, tool)
            if ok and not p:is_installed() then
              p:install()
            end
          end
          ::continue::
        end
      end)
    end,
  },
}
