return {
  {
    "nvchad/ui",
    config = function()
      require("nvchad")
    end,
  },
  {
    "nvchad/base46",
    lazy = true,
    build = function()
      require("base46").compile()
      require("base46").load_all_highlights()
    end,
  },
  {
    "nvzone/minty",
    opts = {},
    cmd = { "Shades", "Huefy" },
    keys = {
      { "<leader>cps", "<CMD>Shades<CR>", "Open Shades Color Picker" },
      { "<leader>cph", "<CMD>Huefy<CR>", "Open Huefy Color Picker" },
    },
  },
  {
    "nvzone/typr",
    dependencies = "nvzone/volt",
    opts = {
      mode = "words",
    },
    cmd = { "Typr", "TyprStats" },
  },
  {
    "nvzone/showkeys",
    cmd = "ShowKeysToggle",
    keys = {
      { "<leader>uk", "<CMD>ShowKeysToggle<CR>", "Show Keypresses" },
    },
    opts = {
      position = "top-right",
      excluded_modes = { "i" },
    },
  },
  {
    "nvzone/timerly",
    cmd = "TimerlyToggle",
    keys = {
      { "<leader>tt", "<CMD>TimerlyToggle<CR>", "Start Pomodoro Timer" },
    },
    opts = {
      position = "top-right",
    },
  },
}
