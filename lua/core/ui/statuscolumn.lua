local statuscolumn = {}

--- Helper function for applying
--- highlight groups.
---@param hl string
---@return string
local function set_hl(hl)
  if type(hl) ~= "string" then
    return ""
  elseif vim.fn.hlexists(hl) == 0 then
    return ""
  else
    return "%#" .. hl .. "#"
  end
end

--- Optional, configuration table.
--- Add this if you like tinkering.
statuscolumn.config = {}

--- Function to create the statuscolumn.
---@return string
statuscolumn.render = function()
  local _statuscolumn = ""

  --- Window whose statuscolumn we are
  --- creating.
  --- No, this is not a typo.
  ---@type integer
  local window = vim.g.statusline_winid

  --- Buffer of the window.
  ---@type integer
  local buffer = vim.api.nvim_win_get_buf(window)

  for _, component in ipairs(statuscolumn.config) do
    local success, part_text = pcall(statuscolumn[component.kind], buffer, window, component)

    if success then
      --- Only add text if a function doesn't fail.
      _statuscolumn = _statuscolumn .. part_text
    end
  end

  return _statuscolumn
end

--- Optional, setup function.
statuscolumn.setup = function(config)
  if type(config) == "table" then
    statuscolumn.config = vim.tbl_deep_extend("force", statuscolumn.config, config)
  end

  vim.o.relativenumber = true
  vim.o.numberwidth = 1

  vim.o.statuscolumn = "%!v:lua.require('core.ui.statuscolumn').render()"
end

return statuscolumn
