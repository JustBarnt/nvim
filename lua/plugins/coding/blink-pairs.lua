return {
  {
    'saghen/blink.pairs',
    dependencies = { "saghen/blink.lib" },
    build = function()
      require("blink-pairs").build():pwait(60000)
    end,
    opts = {}
  }
}
