local icons = Config.ui.icons

return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      Config.lsp.setup()
    end,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "snacks.nvim",        words = { "Snacks" } },
        { path = "lazy.nvim",          words = { "LazyVim" } },
        { path = "buffer-sticks.nvim", words = { "BufferSticks" } }
      },
    },
  },
  {
    "mason-org/mason.nvim",
    build = ":MasonUpdate",
    opts = {
      ui = {
        icons = {
          package_installed = icons.misc.package.installed,
          package_pending = icons.misc.dots,
          package_uninstalled = icons.misc.package.uninstalled,
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
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^7",
    lazy = false
  },
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    config = function()
      require("crates").setup({
        lsp = {
          enabled = true,
          actions = true,
          completion = true,
          hover = true
        }
      })
    end
  },
  {
    "seblyng/roslyn.nvim",
    ft = "cs",
    ---@type RoslynNvimConfig
    opts = {
      filewatching = "auto",
      broad_search = false,
      lock_target = true,
    }
  },
  {
    "justbarnt/codestats.nvim",
    enabled = false,
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("codestats-nvim").setup()
    end
  }
}
