return {
  "stevearc/overseer.nvim",
  ---@module 'overseer'
  ---@type overseer.SetupOpts 
  opts = {
    dap = true,
    output = { use_terminal = false, preserve_output = false },
    form = {
      min_width = 0.4,
      max_width = 0.9,
      min_height = 0.2,
      max_height = 0.9,
      border = "rounded"
    },
  },
  config = function(_, opts)
    local overseer = require('overseer')
    overseer.setup(opts)
    Utils.overseer.setup_template()

    Snacks.keymap.set("n", "<leader>oo", "<CMD>OverseerToggle<CR>", { desc = "Open Overseer Tasks" })
    Snacks.keymap.set("n", "<leader>or", "<CMD>OverseerRun<CR>", { desc = "Run Overseer Task" })
  end
}
