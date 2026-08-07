return {
  {
    'saghen/blink.pairs',
    version = "v0.6.0",
    dependencies = { "saghen/blink.lib" },
    build = require("blink-pairs").build():pwait(60000),
    opts = {}
  }
}
