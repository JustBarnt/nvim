return {
  {
    "DNLHC/glance.nvim",
    event = "VeryLazy",
    opts = {
      preview_win_opts = {
        number = false,
      },
      use_trouble_qf = true
    },
    config = function(_, opts)
      require("glance").setup(opts)
    end
  }
}
