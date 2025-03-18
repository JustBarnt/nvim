---@class helpers.lualine
local M = {}

---@param icon string
---@param status fun(): nil|"ok"|"error"|"pending"
function M.status(icon, status)
  local colors = {
    ok = "Special",
    error = "DiagnosticError",
    pending = "DiagnosticWarn"
  }
  return {
    function()
      return icon
    end,
    cond = function()
      return status() ~= nil
    end,
    color = function()
      return { fg = Snacks.util.color(colors[status()] or colors.ok) }
    end,
  }
end

---@param component any
---@param text string
---@param hl_group? string
---@return string
function M.format(component, text, hl_group)
  text = text:gsub("%%", "%%%%")
  if not hl_group or hl_group == "" then
    return text
  end
  ---@type table<string, string>
  component.hl_cache = component.hl_cache or {}
  local lualine_hl_group = component.hl_cache[hl_group]
  if not lualine_hl_group then
    local utils = require("lualine.utils.utils")
    ---@type string[]
    local gui = vim.tbl_filter(function(x)
      return x
    end, {
      utils.extract_highlight_colors(hl_group, "bold") and "bold",
      utils.extract_highlight_colors(hl_group, "italic") and "italic",
    })
    lualine_hl_group = component:create_hl({
      fg = utils.extract_highlight_colors(hl_group, "fg"),
      gui = #gui > 0 and table.concat(gui, ",") or nil,
    }, "LV_" .. hl_group) --[[@as string]]
  end
  return component:format(lualine_hl_group) .. text .. component:get_default_hl()
end

---@param opts? {relative: "cwd"|"root", modified_hl: string?, directory_hl: string?, filename_hl: string?, modified_sign: string?, readonly_icon: string?, length: number?}function M.pretty_path(opts)
function M.pretty_path(opts)
  opts = vim.tbl_extend("force", {
    relative = "cwd",
    modified_hl = "MatchParen",
    directory_hl = "",
    filename_hl = "Bold",
    modified_sign = "",
    readonly_icon = " 󰌾 ",
    length = 3
  }, opts or {})

  return function(self)
    local path = vim.fn.expand("%:p") --[[@as string]]
    if path == "" then
      return ""
    end
    path = LazyVim.norm(path)
    -- local root = Helpers.root.get({ normalize = true })
    -- local cwd = Helpers.root.cwd()
  end
end

return M
