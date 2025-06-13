---@class helpers.marks
local Marks = {}

Marks.jump_to_mark = function()
  local mark = vim.fn.getcharstr()
  local success = pcall(function()
    vim.cmd("norm! `" .. mark)
  end)

  if not success then
    vim.notify("E20: Mark not set", vim.log.levels.ERROR)
  end
end

Marks.del_all_marks = function()
  vim.cmd [[delmarks!]]
  vim.api.nvim__redraw { statuscolumn = true }
end

Marks.del_mark = function()
  local mark = vim.fn.getcharstr()
  pcall(function()
    vim.cmd("delmark " .. mark)
  end)
  vim.api.nvim__redraw { statuscolumn = true }
end

Marks.mark = function()
  local mark = vim.fn.getcharstr()
  vim.cmd("mark " .. mark)
  vim.api.nvim__redraw { statuscolumn = true }
end

return Marks
