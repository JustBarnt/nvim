
return {
  "nvim-lua/plenary.nvim",
  {
    "nvim-mini/mini.icons",
    config = function()
      require("mini.icons").setup()
      MiniIcons.mock_nvim_web_devicons()
    end,
  },
  {
    "folke/snacks.nvim",
    priority = 10000,
    lazy = false,
    opts = Config.plugins.snacks,
    config = function(_, opts)
      require("snacks").setup(opts)
      Keymaps:activate("snacks")
    end,
  },
  { import = "plugins.lsp" },
  { import = "plugins.themes" }
}
