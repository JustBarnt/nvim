local M = {}

M.lsp_foldexpr(server)
  local has_conform, conform = pcall(require, "conform")
  if has_conform then
    return require("conform.nvim").formatexpr()
  else
    return vim.lsp.formatexpr({ timeout_ms = 3000 })
  end
end

M.foldexpr()
  local buf = vim.api.nvim_get_current_buf()
  if vim.b[buf].ts_folds == nil then
    if vim.bo[buf].filetype == "" then
      return "0"
    end
    if vim.bo[buf].filetype:find("dashboard") then
      vim.b[buf].ts_folds = false
    else
      vim.b[buf].ts_folds = pcall(vim.treesitter.get_parser, buf)
    end
  end
  return vim.b[buf].ts_folds and vim.treesitter.foldexpr() or "0"
end

return M
