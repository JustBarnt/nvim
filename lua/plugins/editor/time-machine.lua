return {
  "y3owk1n/time-machine.nvim",
  cmd = {
    "TimeMachineToggle",
    "TimeMachinePurgeBuffer",
    "TimeMachinePurgeAll",
    "TimeMachineLogShow",
    "TimeMachineLogClear",
  },
  enabled = true,
  version = "*",
  init = function()
    vim.opt.undofile = true
    vim.opt.undodir = vim.fn.expand "~/.local/state/nvim-data/time-machine/"
  end,
  ---@module "time-machine"
  ---@param opts TimeMachine.Config
  opts = function(_, opts)
    local has_diff_tool = vim.fn.executable "delta" == 1
    ---@type TimeMachine.Config
    local cfg = {
      diff_tool = has_diff_tool and "delta" or "native",
    }

    return cfg
  end,
}
