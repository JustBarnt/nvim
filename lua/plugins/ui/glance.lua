return {
  {
    "DNLHC/glance.nvim",
    event = "VeryLazy",
    opts = function()
      local actions = require("glance").actions
      local opts = {
        mappings = {
          list = {
            ["<C-h>"] = actions.enter_win("preview"),
            ["<C-j>"] = actions.next,
            ["<C-K>"] = actions.previous,
          },
          preview = {
            ["<C-q>"] = actions.close,
            ["<C-l>"] = actions.enter_win("list")
          }
        },
        preview_win_opts = {
          number = false,
        },
        use_trouble_qf = true
      }

      return opts
    end,
    config = function(_, opts)
      require("glance").setup(opts)
    end
  }
}
