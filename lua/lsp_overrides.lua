local hover = vim.lsp.buf.hover
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.buf.hover = function(config)
  config = vim.tbl_deep_extend("force", {}, config or {})
  config.border = "rounded"
  hover(config)
end

local signature_help = vim.lsp.buf.signature_help
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.buf.signature_help = function(config)
  config = vim.tbl_deep_extend("force", {}, config or {})
  config.border = "rounded"
  signature_help(config)
end
