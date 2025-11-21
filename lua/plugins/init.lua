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
    opts = Config.snacks.config,
    config = function(_, opts)
      require("snacks").setup(opts)
      for _, value in ipairs(Config.snacks.keys) do
        local lhs, rhs, description = unpack(value)
        vim.keymap.set("n", lhs, rhs, { desc = description })
      end
    end,
  },
  { import = "plugins.lsp" },
  { import = "plugins.themes" }
}
