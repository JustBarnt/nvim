return {
  "justbarnt/betterTerm.nvim",
  init = function()
    vim.api.nvim_create_user_command("BetterTermOpen", function(opts)
      require("betterTerm").open(tonumber(opts.args))
    end, { nargs = 1, complete = nil, desc = "Open Terminal {n}" })
    vim.api.nvim_create_user_command("SelectBetterTerm", function(opts)
      require("betterTerm").select()
    end, { desc = "Select BetterTerminal" })
  end,
  keys = {
    { mode = { "n", "t" }, "<leader>;", "<CMD>BetterTermOpen 0<CR>", desc = "Open BetterTerminal 0" },
    { mode = { "n", "t" }, "<leader>tt", "<CMD>SelectBetterTerm<CR>", desc = "Select BetterTerm" },
  },
  opts = {
    prefix = "Term_",
    position = "bot",
    size = 15,
  },
}
