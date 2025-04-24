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
        -- prettier = {
        --   condition = function(_, ctx)
        --     local ft = vim.bo[ctx.buf].filetype --[[@as string]]
        --     -- default filetypes are always supported
        --     if vim.tbl_contains({ "svelte" }, ft) then
        --       return true
        --     end
        --     -- otherwise, check if a parser can be inferred
        --     local ret = vim.fn.system({ "prettier", "--file-info", ctx.filename })
        --     ---@type boolean, string?
        --     local ok, parser = pcall(function()
        --       return vim.fn.json_decode(ret).inferredParser
        --     end)
        --     return ok and parser and parser ~= vim.NIL or false
        --   end,
        -- },
        xmlformat = {
          prepend_args = { "--selfclose", "--indent", "4", "--preserve", "literal" },
        },
      },
      formatters_by_ft = {
        xml = { "xmlformat" },
        json = { "biome" },
        jsonc = { "biome" },
        css = { "biome" },
        svelte = { "prettier" },
        javascript = { "biome" },
        typescript = { "biome" },
        html = { "biome", "prettier", stop_after_first = true },
        lua = { "stylua" },
        go = { "goimports", "gofumpt" },
      },
    }
    return opts
  end,
  config = function(_, opts)
    require("conform").setup(opts)
  end,
}
