return {
  "neovim/nvim-lspconfig",
  dependencies = {
    { "williamboman/mason.nvim", opts = {} },
    { "williamboman/mason-lspconfig.nvim", lazy = false },
    { "b0o/SchemaStore.nvim", version = false },
    {
      "saghen/blink.cmp",
      opts_extend = { "sources.default" }
    },
    "WhoIsSethDaniel/mason-tool-installer.nvim"
  },
  config = function(_, opts)
    -- LSP servers and clients (like Neovim) are able to communicate to each other what
    -- features they support.
    -- By default, Neovim doesn't support everything that is in the LSP Specification.
    -- When you add nvim-cmp, blink, luasnip, etc. Neovim now has *more* capabilities.
    -- So, we create new capabilities here, and then broadcast that to the LSP servers.

    local client_capabilities = vim.tbl_deep_extend(
      "force",
      vim.lsp.protocol.make_client_capabilities(),
      require("blink.cmp").get_lsp_capabilities()
    )

  end
  }
