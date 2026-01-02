return {
  "danymat/neogen",
  config = function()
    require("neogen").setup({
      snippet_engine = "luasnip",
      languages = {
        ['svelte'] = require("neogen.configurations.javascript")
      }
    })
  end
}
