-- Download pre-built binaries
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local data = ev.data
    local spec = data.spec
    if spec.name == "blink-pairs" and (data.kind == "install" or data.kind == "update") then
      require("blink-pairs").build():pwait(60000)
    end
  end,
})

vim.pack.add {
  { src = "saghen/blink.compat", version = vim.version.range("2.*") },
  { src = "saghen/blink.pairs", version = vim.version.range("0.5.0") },
  { src = "saghen/blink.cmp", version = vim.version.range("1.10.1") },
}

require("blink-compat").setup {}
require("blink-pairs").setup {}
require("blink-cmp").setup {
  appearance = Utils.blink.appearance,
  fuzzy = Utils.blink.fuzzy,
  keymap = Utils.blink.keymap_type,
  cmdline = Utils.blink.cmdline,
  completion = Utils.blink.completion,
  signature = Utils.blink.signature,
  sources = Utils.blink.sources,
}
