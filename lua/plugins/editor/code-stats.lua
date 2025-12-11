return {
  "justbarnt/codestats.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("codestats-nvim").setup()
  end
}
