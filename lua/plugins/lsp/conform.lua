return {
  "stevearc/conform.nvim",
  dependencies = { "mason.nvim" },
  lazy = true,
  cmd = "ConformInfo",
  opts = function()
    ---@type conform.setupOpts
    local opts = {
      default_format_opts = {
        timeout_ms = 500,
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
        topiary_nu = {
          command = "topiary",
          args = { "format", "--language", "nu" },
        },
        injected = {
          options = {
            ignore_errors = true,
          },
        },
      },
      formatters_by_ft = {
        xml = { "xmlformat" },
        nu = { "topiary_nu" },
        json = { "biome" },
        jsonc = { "biome" },
        css = { "biome" },
        svelte = { "prettier" },
        javascript = { "biome" },
        typescript = { "biome" },
        html = { "biome", "prettier", stop_after_first = true },
        lua = { "stylua" },
        go = { "goimports", "gofumpt" },
        log = { "injected" },
      },
    }
    return opts
  end,
  config = function(_, opts)
    require("conform").setup(opts)
  end,
}
