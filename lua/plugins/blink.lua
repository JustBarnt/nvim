return {
  "saghen/blink.cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  version = "v1.*",
  --build = "cargo build --release",
  ---@module "blink.cmp"
  ---@type blink.cmp.Config
  opts = {
    fuzzy = Config.plugins.lsp.blink.fuzzy,
    keymap = Config.plugins.lsp.blink.keymap_type,
    cmdline = Config.plugins.lsp.blink.cmdline,
    completion = Config.plugins.lsp.blink.completion,
    signature = Config.plugins.lsp.blink.signature,
    sources = Config.plugins.lsp.blink.sources 
  }
}
