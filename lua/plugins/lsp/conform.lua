return {
  "stevearc/conform.nvim",
  dependencies = { "mason.nvim" },
  lazy = true,
  cmd = "ConformInfo",
  keys = {
    {
      "<leader>cF",
      function()
        require("conform").format { formatters = { "injected" }, timeout_ms = 3000 }
      end,
      mode = { "n", "v" },
      desc = "Format Injected Langs",
    },
  },
  opts = function()
    ---@type conform.setupOpts
    local opts = {
      default_format_opts = {
        timeout_ms = 500,
        async = true,
        quiet = false,
        lsp_format = "fallback",
      },
      formatters = {
        biome = {
          require_cwd = true,
        },
        topiary_nu = {
          command = "topiary",
          args = { "format", "--language", "nu" },
        },
        ["xstyler"] = {
          command = "xstyler",
          args = { "--write-to-stdout", "--take-pipe" },
        },
        injected = {
          options = {
            ignore_errors = true,
            lang_to_formatters = {
              json = { "jq" },
              xml = { "xmlformat" },
            },
          },
        },
      },
      formatters_by_ft = {
        cpp = { "clang-format" },
        c_sharp = { "clang-format" },
        nu = { "topiary_nu" },
        json = { "jq" },
        jsonc = { "biome" },
        css = { "biome" },
        svelte = { "prettier" },
        javascript = { "clang-format" },
        typescript = { "clang-format" },
        html = { "biome", "prettier", stop_after_first = true },
        lua = { "stylua" },
        go = { "goimports", "gofumpt" },
        log = { "injected" },
        axaml = { "xstyler" }
      },
    }
    return opts
  end,
  config = function(_, opts)
    require("conform").setup(opts)
  end,
}
