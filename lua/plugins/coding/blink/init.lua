local completion = require("plugins.coding.blink.completion")
local cmdline = require("plugins.coding.blink.cmdline")
local signature = require("plugins.coding.blink.signature")
local sources   = require("plugins.coding.blink.sources")


return {
  "saghen/blink.cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  version = "v1.*",
  -- build = "cargo build --release",
  ---@module "blink.cmp"
  ---@type blink.cmp.Config
  opts = {
    fuzzy = { implementation = "prefer_rust" },
    keymap = { preset = "default" },
    cmdline = cmdline,
    completion = completion,
    signature = signature,
    sources = sources,
  },
}
