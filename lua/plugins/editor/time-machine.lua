return {
  "y3owk1n/time-machine.nvim",
  enabled = false,
  version = "*",
  init = function()
    vim.opt.undofile = true
    vim.opt.undodir = vim.fn.expand "~/.local/state/nvim-data/time-machine/"
  end,
  opts = function(_, opts)
    local has_delta = vim.fn.executable("delta") == 1
    return {
      diff_tool = has_delta and "delta" or "native",
      external_diff_args = { "-s" },
    } 
  end
}
