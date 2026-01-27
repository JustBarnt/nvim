return {
  "y3owk1n/time-machine.nvim",
  cmd = {
    "TimeMachineToggle",
    "TimeMachinePurgeBuffer",
    "TimeMachinePurgeAll",
    "TimeMachineLogShow",
    "TimeMachineLogClear",
  },
  init = function()
    vim.opt.undofile = true
    vim.opt.undodir = vim.fn.expand("~/.local/state/nvim-data/time-machine/")
  end,
  ---@module "time-machine"
  ---@type TimeMachine.Config
  opts = {
    diff_tool = vim.fn.executable "delta" == 1 and "delta" or "native",

  },
  keys = {
    { "<leader>tt", "<CMD>TimeMachineToggle<CR>", desc = "Toggle Time-Machine" },
  }
}
