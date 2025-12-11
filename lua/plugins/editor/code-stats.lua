return {
  "justbarnt/codestats.nvim",
  enabled = false,
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("codestats-nvim").setup()
  end
}
