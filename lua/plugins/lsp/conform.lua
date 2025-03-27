return {
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
}
