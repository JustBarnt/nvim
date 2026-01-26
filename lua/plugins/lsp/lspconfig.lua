return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      Config.lsp.setup()
    end,
  }
}
