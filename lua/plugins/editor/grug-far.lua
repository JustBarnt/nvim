return {
  "MagicDuck/grug-far.nvim",
  config = function()
    Utils.keymaps.enable({
      { { "n" }, "<leader>frw",  function() require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } }) end, { desc = "Find and Replace <CWORD>" } },
      { { "n" }, "<leader>fra",  function() require("grug-far").open({ engine = 'astgrep' }) end,                               { desc = "Find and Replace with AstGrep" } },
      { { "n" }, "<leader>frr",  function() require("grug-far").open({ transient = true }) end,                                 { desc = "Find and Replace" } },
      { { "n" }, "<leader>frb",  function() require("grug-far").open({ prefills = { path = vim.fn.expand("%") } }) end,         { desc = "Find and Replace in Buffer" } },
    })
  end
}
