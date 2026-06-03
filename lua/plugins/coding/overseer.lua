return {
  "stevearc/overseer.nvim",
  ---@module 'overseer'
  ---@type overseer.SetupOpts 
  opts = {
    dap = true,
    output = { use_terminal = true, preserve_output = false },
  },
  config = function(_, opts)
    local overseer = require('overseer')
    overseer.setup(opts)

    Utils.overseer.setup_template()
  end
}
