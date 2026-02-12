return {
  {
    "gisketch/triforce.nvim",
    dependencies = { "nvzone/volt" },
    keys = {
      { "<leader>sT", function() require("triforce").show_profile() end, desc = "Show Triforce Stats" },
    },
    opts = {
      keymap = { show_profile = nil },
      xp_rewards = {
        char = 0.5,
        line = 1,
        save = 50,
      },
    },
    config = function(_, opts)
      require("triforce").setup(opts)

      require("triforce.lualine").setup({
        level = {
          prefix = "Level ",
          bar = { chars = { filled = "", empty = "" }, length = 5 },
          show = { percent = true }
        }
      })
    end
  },
}
