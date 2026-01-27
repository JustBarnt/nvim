return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  keys = {
    { "<leader>?",    function() require("which-key").show({ global = false }) end,              desc = "Buffer Keymaps" },
    { "<c-w><space>", function() require("which-key").show({ keys = "<c-w>", loop = true }) end, desc = "Window Hydra Mode" }
  },
  opts = {
    defaults = {},
    expand = 1,
    preset = "modern",
    plugins = {
      marks = false,
      registers = false,
    },
    keys = {
      scroll_down = "<C-n>",
      scroll_up = "<C-p>"
   },
    spec = {
      {
        mode = { "n", "v" },
        { "<leader>b",  group = "Buffer", expand = function() return require("which-key.extras").expand.buf() end },
        { "<leader>c",  group = "Code" },
        { "<leader>d",  group = "Delete", },
        { "<leader>f",  group = "Files" },
        { "<leader>g",  group = "Git" },
        { "<leader>gh", group = "Git Hunks" },
        { "<leader>m",  group = "Marks" },
        { "<leader>r",  group = "Rustaceanvim" },
        { "<leader>s",  group = "Search" },
        { "<leader>t",  group = "TimeMachine/Terminal" },
        { "<leader>w",  group = "Windows", proxy = "<c-w>", expand = function() return require("which-key.extras").expand.win() end },
        { "<leader>x",  group = "Diagnostics" },
        { "[",          group = "Pevious" },
        { "]",          group = "Next" },
        { "g",          group = "LSP/Global" },
        { "z",          group = "Folds" },
      }
    }
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
  end
}
