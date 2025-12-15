
return {
  "nvim-lua/plenary.nvim",
  {
    "nvim-mini/mini.icons",
    config = function()
      require("mini.icons").setup({
        style = "glyph",
        file = {
          ["artisan"] = { glyph = "", hl = "MiniIconsRed" },
          [".axaml"] = { glyph = "󰙳", hl = "MiniIconsGreen" },
          [".xaml"] = { glyph = "󰙳", hl = "MiniIconsGreen" },
          [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
          [".eslintrc.js"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
          [".node-version"] = { glyph = " ", hl = "MiniIconsGreen" },
          [".yarnrc.yml"] = { glyph = "", hl = "MiniIconsBlue" },
          ["eslint.config.js"] = { glyph = "󰱺 ", hl = "MiniIconsYellow" },
          ["package.json"] = { glyph = " ", hl = "MiniIconsGreen" },
          ["tsconfig.json"] = { glyph = " ", hl = "MiniIconsAzure" },
          ["tsconfig.build.json"] = { glyph = " ", hl = "MiniIconsAzure" },
          ["yarn.lock"] = { glyph = "", hl = "MiniIconsBlue" },
          ["composer.lock"] = { glyph = "", hl = "MiniIconsPurple"},
        },
        filetype = {
          axaml = { glyph = "󰙳 ", hl = "MiniIconsGreen" },
          xaml = { glyph = "󰙳 ", hl = "MiniIconsGreen" },
        },
      })
      MiniIcons.mock_nvim_web_devicons()
    end,
  },
  { import = "plugins.coding" },
  { import = "plugins.editor" },
  { import = "plugins.lsp" },
  { import = "plugins.themes" },
  { import = "plugins.utilities" }
}
