---@class vim.lsp.Config
return {
  cmd = { "tailwindcss-language-server", "--stdio" },
  root_markers = {
    "tailwind.config.js",
    "tailwind.config.cjs",
    "tailwind.config.mjs",
    "tailwind.config.ts",
    "postcss.config.js",
    "postcss.config.cjs",
    "postcss.config.mjs",
    "postcss.config.ts",
  },
  filetypes = {
    "html",
    -- 'markdown',
    "php",
    "razor",
    -- css
    "css",
    "less",
    "postcss",
    "sass",
    "scss",
    -- js
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    -- mixed
    "svelte",
  },
  settings = {
    tailwindCSS = {
      validate = true,
      emmetCompletions = true,
      lint = {
        cssConflict = "warning",
        invalidApply = "error",
        invalidScreen = "error",
        invalidVariant = "error",
        invalidConfigPath = "error",
        invalidTailwindDirective = "error",
        recommendedVariantOrder = "warning",
      },
      classAttributes = {
        "class",
        "className",
        "class:list",
        "classList",
        "ngClass",
      },
    },
  },
  on_new_config = function(new_config)
    if not new_config.settings then
      new_config.settings = {}
    end
    if not new_config.settings.editor then
      new_config.settings.editor = {}
    end
    if not new_config.settings.editor.tabSize then
      -- set tab size for hover
      new_config.settings.editor.tabSize = vim.lsp.util.get_effective_tabstop()
    end
  end,
}
