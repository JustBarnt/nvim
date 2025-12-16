return {
  "saghen/blink.cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = { 
    {
      "L3MON4D3/LuaSnip",
      version = "v2.*",
      -- build = "make install_jsregexp"
    }
  },
  version = "v1.*",
  --build = "cargo build --release",
  ---@module "blink.cmp"
  ---@type blink.cmp.Config
  opts = {
    snippets = { preset = "luasnip" },
    fuzzy = Config.plugins.lsp.blink.fuzzy,
    keymap = Config.plugins.lsp.blink.keymap_type,
    cmdline = Config.plugins.lsp.blink.cmdline,
    completion = Config.plugins.lsp.blink.completion,
    signature = Config.plugins.lsp.blink.signature,
    sources = Config.plugins.lsp.blink.sources 
  }
}
