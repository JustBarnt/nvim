vim.pack.add({
  -- Blink Plugins
  { src = "saghen/blink.compat", version = vim.version.range("2.*") },
  { src = "saghen/blink.pairs",  version = vim.version.range("0.5.0") },
  { src = "saghen/blink.cmp",    version = vim.version.range("1.10.1") },

    -- Nuget Manager
  { src = "MonsieurTib/neonuget" },
  -- Surround Text Objects
  { src = "kylechui/nvim-surround" },
  -- Command Runner
  { src = "stevearc/overseer.nvim" },
  -- Simple Comment strings
  { src = "ts-comments.lua" }
})
