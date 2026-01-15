local flash_remote_opts = { remote_op = { restore = true, motion = false } }
local flash_inc_select  = { actions = { ["<c-space>"] = "next", ["<BS>"] = "prev" } }

return {
  {
    "nacro90/numb.nvim",
    event = "VeryLazy"
  },
  {
    "saghen/blink.indent",
    opts = {}
  },
  {
    "MagicDuck/grug-far.nvim",
    config = function()
      Utils.keymaps.enable({
        { { "n" }, "<leader>frw", function() require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } }) end, { desc = "Find and Replace <CWORD>" } },
        { { "n" }, "<leader>fra", function() require("grug-far").open({ engine = 'astgrep' }) end,                              { desc = "Find and Replace with AstGrep" } },
        { { "n" }, "<leader>fr", function() require("grug-far").open({ transient = true }) end,                                 { desc = "Find and Replace" } },
        { { "n" }, "<leader>frb", function() require("grug-far").open({ prefills = { path = vim.fn.expand("%") } }) end,        { desc = "Find and Replace in Buffer" } },
      })
    end
  },
  {
    "folke/todo-comments.nvim",
    event = "BufReadPre",
    opts = {},
    config = function(_, opts)
      require("todo-comments").setup(opts)
    end
  },
  {
    "folke/trouble.nvim",
    opts = {
      modes = {
        lsp = {
          win = { position = "right" }
        }
      }
    },
  },
  {
    "sQVe/sort.nvim",
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {
      modes = {
        char = {
          jump_labels = true
        },
        search = {
          enabled = true
        }
      },
    },
    -- stylua: ignore
    keys = {
      { "s",         mode = { "n", "x", "o" }, function() require("flash").jump() end,                       desc = "Flash" },
      { "S",         mode = { "n", "o", "x" }, function() require("flash").treesitter() end,                 desc = "Flash Treesitter" },
      { "r",         mode = "o",               function() require("flash").remote(flash_remote_opts) end,    desc = "Remote Flash" },
      { "R",         mode = { "o", "x" },      function() require("flash").treesitter_search() end,          desc = "Treesitter Search" },
      { "<c-space>", mode = { "n", "x", "o" }, function() require("flash").treesitter(flash_inc_select) end, desc = "Treesitter Incremental Selection" },
      { "<c-s>",     mode = { "c" },           function() require("flash").toggle() end,                     desc = "Toggle Flash Search" },
    },
  },
  {
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
      { "<leader>tt", "<CMD>TimeMachineToggle<CR>", desc = "Toggle Tree" },
    }
  }
}
