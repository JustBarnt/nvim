return {
  {
    "nacro90/numb.nvim",
    event = "VeryLazy"
  },
  {
    "saghen/blink.indent",
    opts = {}
  },
  {
    "MagicDuck/grug-far.nvim",
    config = function()
      Utils.keymaps.enable({
        { { "n" }, "<leader>frw", function() require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } }) end, { desc = "Find and Replace <CWORD>" } },
        { { "n" }, "<leader>fra", function() require("grug-far").open({ engine = 'astgrep' }) end,                              { desc = "Find and Replace with AstGrep" } },
        { { "n" }, "<leader>fr", function() require("grug-far").open({ transient = true }) end,                                 { desc = "Find and Replace" } },
        { { "n" }, "<leader>frb", function() require("grug-far").open({ prefills = { path = vim.fn.expand("%") } }) end,        { desc = "Find and Replace in Buffer" } },
      })
    end
  },
  {
    "folke/todo-comments.nvim",
    event = "BufReadPre",
    opts = {},
    config = function(_, opts)
      require("todo-comments").setup(opts)
    end
  },
  {
    "folke/trouble.nvim",
    opts = {
      modes = {
        lsp = {
          win = { position = "right" }
        }
      }
    },
  },
  {
    "sQVe/sort.nvim",
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
      { "S",     mode = { "n", "o", "x" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
      { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },
  }
}
