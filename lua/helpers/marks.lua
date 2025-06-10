---@class helpers.marks
local Marks = {}

Marks.jump_to_mark = function()
  local mark = vim.fn.getcharstr()
  vim.cmd("norm! `" .. mark)
end

Marks.del_all_marks = function()
  vim.cmd [[delmarks!]]
  vim.api.nvim__redraw { statuscolumn = true }
end

Marks.del_mark = function()
  local mark = vim.fn.getcharstr()
  vim.cmd("delmark " .. mark)
  vim.api.nvim__redraw { statuscolumn = true }
end

Marks.mark = function()
  local mark = vim.fn.getcharstr()
  vim.cmd("mark " .. mark)
  vim.api.nvim__redraw { statuscolumn = true }
end

return Marks
