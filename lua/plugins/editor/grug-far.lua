return {
  "MagicDuck/grug-far.nvim",
  event = "VeryLazy",
  keys = {
    { "<leader>frw", function() require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } }) end, desc = "Find and Replace <CWORD>" },
    { "<leader>fra", function() require("grug-far").open({ engine = 'astgrep' }) end,                               desc = "Find and Replace with AstGrep" },
    { "<leader>frr", function() require("grug-far").open({ transient = true }) end,                                 desc = "Find and Replace" },
    { "<leader>frb", function() require("grug-far").open({ prefills = { path = vim.fn.expand("%") } }) end,         desc = "Find and Replace in Buffer" },
  },
}
