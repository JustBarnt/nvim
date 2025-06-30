---@module 'blink-cmp'
---@class blink.cmp.SourceConfigPartial
return {
  -- add lazydev to your completion providers
  default = { "lsp", "path", "snippets", "buffer" },
  per_filetype = {
    lua = { inherit_defaults = true, "lazydev" },
  },
  providers = {
    lazydev = {
      name = "LazyDev",
      module = "lazydev.integrations.blink",
      -- make lazydev completions top priority (see `:h blink.cmp`)
      score_offset = 100,
    },
    lsp = { fallbacks = {} },
  },
}
