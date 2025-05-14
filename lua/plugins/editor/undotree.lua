return {
  "mbbill/undotree",
  event = "VeryLazy",
  init = function()
    vim.g.undotree_WindowLayout = 2
    if vim.fn.has("win32") == 1 then
      vim.g.undotree_DiffCommand = "FC"
    end
  end,
}
