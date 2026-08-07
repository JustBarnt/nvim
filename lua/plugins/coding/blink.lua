return {
  {
    "saghen/blink.compat",
    version = "2.*",
    lazy = true,
    opts = {}
  },
  {
    "saghen/blink.cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    version = "v1.10.2",
    -- build = "cargo build --release",
    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
      appearance = Utils.blink.appearance,
      fuzzy = Utils.blink.fuzzy,
      keymap = Utils.blink.keymap_type,
      cmdline = Utils.blink.cmdline,
      completion = Utils.blink.completion,
      signature = Utils.blink.signature,
      sources = Utils.blink.sources,
    },
  },
}
