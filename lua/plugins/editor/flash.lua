local flash_remote_opts = { remote_op = { restore = true, motion = false } }
local flash_inc_select  = { actions = { ["<c-space>"] = "next", ["<BS>"] = "prev" } }

return {
  "justbarnt/flash.nvim",
  event = "VeryLazy",
  ---@type Flash.Config
  opts = {},
  -- stylua: ignore
  keys = {
    { "s",         mode = { "n", "x", "o" }, function() require("flash").jump() end,                       desc = "Flash" },
    { "S",         mode = { "n", "o", "x" }, function() require("flash").treesitter() end,                 desc = "Flash Treesitter" },
    { "r",         mode = "o",               function() require("flash").remote(flash_remote_opts) end,    desc = "Remote Flash" },
    { "R",         mode = { "o", "x" },      function() require("flash").treesitter_search() end,          desc = "Treesitter Search" },
    { "<c-space>", mode = { "n", "x", "o" }, function() require("flash").treesitter(flash_inc_select) end, desc = "Treesitter Incremental Selection" },
    { "<c-s>",     mode = { "c" },           function() require("flash").toggle() end,                     desc = "Toggle Flash Search" },
  },
}
