---@class vim.lsp.Config
return {
  cmd = { "tailwindcss-language-server", "--stdio" },
  root_dir = function(bufnr, on_dir)
    local root_files = {
      "tailwind.config.js",
      "tailwind.config.cjs",
      "tailwind.config.mjs",
      "tailwind.config.ts",
      "postcss.config.js",
      "postcss.config.cjs",
      "postcss.config.mjs",
      "postcss.config.ts",
    }
    local fname = vim.api.nvim_buf_get_name(bufnr)
    root_files = Helpers.insert_package_json(root_files, "tailwindcss", fname)
    on_dir(vim.fs.dirname(vim.fs.find(root_files, { path = fname, upward = true })[1]))
  end,
  on_init = function(client)
    Helpers.lsp.on_init(client, {
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
          "classes",
        },
      },
    })
  end,
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
  before_init = function(_, config)
    if not config.settings then
      config.settings = {}
    end
    if not config.settings.editor then
      config.settings.editor = {}
    end
    if not config.settings.editor.tabSize then
      config.settings.editor.tabSize = vim.lsp.util.get_effective_tabstop()
    end
  end,
  workspace_required = true,
}
