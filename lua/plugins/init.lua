
return {
  "nvim-lua/plenary.nvim",
  {
    "nvim-mini/mini.icons",
    config = function()
      require("mini.icons").setup()
      MiniIcons.mock_nvim_web_devicons()
    end,
  },
  { import = "plugins.lsp" },
  { import = "plugins.themes" },
  { import = "plugins.utilities" }
}
