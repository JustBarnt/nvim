local util = require "lspconfig.util"
---@type vim.lsp.Config
return {
  cmd = { 'laravel-ls' },
  root_dir = function(bufnr, on_dir)
    local root_files = {
      "artisan",
    }
    local fname = vim.api.nvim_buf_get_name(bufnr)
    root_files = util.root_markers_with_field({}, {'package.json', 'package.json5' }, 'laravel', vim.api.nvim_buf_get_name(0))
    on_dir(vim.fs.dirname(vim.fs.find(root_files, { path = fname, upward = true })[1]))
  end,
  filetypes = { 'php', 'blade' },
  root_markers = { 'artisan' },
  workspace_required = true
}
