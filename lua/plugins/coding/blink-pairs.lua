return {
  {
    'saghen/blink.pairs',
    enabled = false,
    dependencies = { "saghen/blink.lib" },
    build = function()
      require("blink-pairs").build():pwait(60000)
    end,
    opts = {}
  }
}
