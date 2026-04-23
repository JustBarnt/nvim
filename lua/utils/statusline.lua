local icons = require("utils.statusline-icons")

---@class utils.statusline
local M = {}

local separators = {
  compontent = { left = "", right = "" },
  section = { left = "", right = "" }
}

---@param group string
---@return string
local sl_hl = function(group)
  return "%#" .. group .. "#"
end

---@param group string
---@return vim.api.keyset.get_hl_info
local get_hl = function(group)
  return vim.api.nvim_get_hl(0, { name = group, link = false, create = false })
end

---@param icon CustomIcon
---@return string
local highlight_icon = function(icon)
  return sl_hl(icon.group) .. icon.symbol .. sl_hl("StatusLine")
end

local set_hl_groups = function()
  ---@type table<string, vim.api.keyset.highlight>
  local statusline_groups = {
    StatusLineModeNormal = { fg = get_hl("StatusLine").bg, bg = get_hl("StatusLine").fg },
    StatusLineModePending = { fg = get_hl("StatusLine").bg, bg = get_hl("Comment").fg },
    StatusLineModeVisual = { fg = get_hl("StatusLine").bg, bg = get_hl("SpecialKey").fg },
    StatusLineModeInsert = { fg = get_hl("StatusLine").bg, bg = get_hl("diffAdded").fg },
    StatusLineModeCommand = { fg = get_hl("StatusLine").bg, bg = get_hl("Number").fg },
    StatusLineModeReplace = { fg = get_hl("StatusLine").bg, bg = get_hl("Constant").fg },
    StatusLineModeOther = { link = "StatusLine" },
    StatusLineBold = { bold = true },
    StatusLineDim = { fg = get_hl("LineNr").fg },
    StatusLineDimItalic = { fg = get_hl("LineNr").fg, italic = true },
    StatusLineInverted = { link = "StatusLineModeNormal" },
    StatusLineDiffAdded = { fg = get_hl("diffAdded").fg },
    StatusLineDiffChanged = { fg = get_hl("diffChanged").fg },
    StatusLineDiffRemoved = { fg = get_hl("diffRemoved").fg },

    -- Section separators (transition from colored block back to statusline bg)
    StatusLineModeNormalSep  = { fg = get_hl("StatusLine").fg,  bg = get_hl("StatusLine").bg },
    StatusLineModePendingSep = { fg = get_hl("Comment").fg,     bg = get_hl("StatusLine").bg },
    StatusLineModeVisualSep  = { fg = get_hl("SpecialKey").fg,  bg = get_hl("StatusLine").bg },
    StatusLineModeInsertSep  = { fg = get_hl("diffAdded").fg,   bg = get_hl("StatusLine").bg },
    StatusLineModeCommandSep = { fg = get_hl("Number").fg,      bg = get_hl("StatusLine").bg },
    StatusLineModeReplaceSep = { fg = get_hl("Constant").fg,    bg = get_hl("StatusLine").bg },
    -- Right side separators (transition from statusline bg into colored block)
    StatusLineInvertedSep    = { fg = get_hl("StatusLine").fg,  bg = get_hl("StatusLine").bg },
    StatusLineInsertSep      = { fg = get_hl("diffAdded").fg,   bg = get_hl("StatusLine").bg },
  }

  for group, opts in pairs(statusline_groups) do
    vim.api.nvim_set_hl(0, group, opts)
  end
end

set_hl_groups()

-- Re-apply highlights when colorscheme changes
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("barnt/statusline_colors", { clear = true }),
  desc = "Re-apply statusline highlights on colorscheme change",
  callback = set_hl_groups,
})

---@return string
local mode_component = function()
	-- Note that: \19 = ^S and \22 = ^V.
	-- stylua: ignore start
	local mode_settings = {
		["n"]     = { name = "NORMAL",     hl = "Normal" },
		["no"]    = { name = "OP-PENDING", hl = "Pending" },
		["nov"]   = { name = "OP-PENDING", hl = "Pending" },
		["noV"]   = { name = "OP-PENDING", hl = "Pending" },
		["no\22"] = { name = "OP-PENDING", hl = "Pending" },
		["niI"]   = { name = "NORMAL",     hl = "Normal" },
		["niR"]   = { name = "NORMAL",     hl = "Normal" },
		["niV"]   = { name = "NORMAL",     hl = "Normal" },
		["nt"]    = { name = "NORMAL",     hl = "Normal" },
		["ntT"]   = { name = "NORMAL",     hl = "Normal" },
		["v"]     = { name = "VISUAL",     hl = "Visual" },
		["vs"]    = { name = "VISUAL",     hl = "Visual" },
		["V"]     = { name = "V-LINE",     hl = "Visual" },
		["Vs"]    = { name = "V-LINE",     hl = "Visual" },
		["\22"]   = { name = "V-BLOCK",    hl = "Visual" },
		["\22s"]  = { name = "V-BLOCK",    hl = "Visual" },
		["s"]     = { name = "SELECT",     hl = "Insert" },
		["S"]     = { name = "S-LINE",     hl = "Normal" },
		["\19"]   = { name = "S-BLOCK",    hl = "Normal" },
		["i"]     = { name = "INSERT",     hl = "Insert" },
		["ic"]    = { name = "INSERT",     hl = "Insert" },
		["ix"]    = { name = "INSERT",     hl = "Insert" },
		["R"]     = { name = "REPLACE",    hl = "Replace" },
		["Rc"]    = { name = "REPLACE",    hl = "Replace" },
		["Rx"]    = { name = "REPLACE",    hl = "Replace" },
		["Rv"]    = { name = "V-REPLACE",  hl = "Replace" },
		["Rvc"]   = { name = "V-REPLACE",  hl = "Replace" },
		["Rvx"]   = { name = "V-REPLACE",  hl = "Replace" },
		["c"]     = { name = "COMMAND",    hl = "Command" },
		["cv"]    = { name = "EX",         hl = "Command" },
		["ce"]    = { name = "EX",         hl = "Command" },
		["r"]     = { name = "REPLACE",    hl = "Normal" },
		["rm"]    = { name = "MORE",       hl = "Normal" },
		["r?"]    = { name = "CONFIRM",    hl = "Normal" },
		["!"]     = { name = "SHELL",      hl = "Normal" },
		["t"]     = { name = "TERMINAL",   hl = "Command" },
	}
  -- stylua: ignore end

  local settings = mode_settings[vim.api.nvim_get_mode().mode] or {}
  local mode = settings.name or "UNKNOWN"
  local hl = settings.hl or "Other"

  return sl_hl("StatusLineMode" .. hl)
    .. " " .. mode .. " "
    .. sl_hl("StatusLineMode" .. hl .. "Sep")
    .. separators.section.left
end

vim.api.nvim_create_autocmd("User", {
  pattern = "GitSignsUpdate",
  group = vim.api.nvim_create_augroup("barnt/statusline_gitsigns", { clear = true }),
  command = "redrawstatus",
})

---@return string?
local git_component = function()
  local head = vim.b.gitsigns_head
  if not head or head == "" then
    return
  end

  local component = highlight_icon(icons.misc.branch) .. " " .. sl_hl("StatusLine") .. head

  local dict = vim.b.gitsigns_status_dict
  if dict then
    local parts = {}
    if (dict.added or 0) > 0 then
      table.insert(parts, sl_hl("StatusLineDiffAdded") .. Utils.ui.icons.git.added .. dict.added .. " ")
    end
    if (dict.changed or 0) > 0 then
      table.insert(parts, sl_hl("StatusLineDiffChanged") .. Utils.ui.icons.git.modified .. dict.changed .. " ")
    end
    if (dict.removed or 0) > 0 then
      table.insert(parts, sl_hl("StatusLineDiffRemoved") .. Utils.ui.icons.git.removed .. dict.removed .. " ")
    end
		if #parts > 0 then
			component = component .. " " .. table.concat(parts, sl_hl("StatusLine"))
		end
  end
	return component .. separators.compontent.left
end

---@return string?
local dap_component = function()
  if not package.loaded["dap"] or require("dap").status() == "" then
    return
  end

  return string.format("%%#%s#%s  %s", "Special", icons.misc.bug.symbol, require("dap").status())
end

---@type table<string, string?>
local progress_status = {
  client = nil,
  kind = nil,
  title = nil,
}

vim.api.nvim_create_autocmd("LspProgress", {
  group = vim.api.nvim_create_augroup("barnt/statusline", { clear = true }),
  desc = "Update LSP progress in statusline",
  pattern = { "begin", "end" },
  callback = function(args)
    -- This should in theory never happen, but I've seen weird errors.
    if not args.data then
      return
    end

    progress_status = {
      client = vim.lsp.get_client_by_id(args.data.client_id).name,
      kind = args.data.params.value.kind,
      title = args.data.params.value.title,
    }

    if progress_status.kind == "end" then
      progress_status.title = nil
      -- Wait a bit before clearing the status.
      vim.defer_fn(function()
        vim.api.nvim__redraw { statusline = true }
      end, 3000)
    else
      vim.api.nvim__redraw { statusline = true }
    end
  end,
})

---@return string?
local lsp_progress_component = function()
  if not progress_status.client or not progress_status.title then
    return
  end

  -- Avoid noisy messages while typing.
  if vim.startswith(vim.api.nvim_get_mode().mode, "i") then
    return
  end

  return highlight_icon(icons.misc.lsp)
    .. " "
    .. sl_hl("StatusLineDim")
    .. progress_status.client
    .. ": "
    .. sl_hl("StatusLineDimItalic")
    .. progress_status.title
end

---@return string?
local lsp_clients_component = function()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if #clients == 0 then
		return 
	end

	local names = vim.iter(clients):map(function(c) return c.name end):totable()
	return highlight_icon(icons.misc.lsp)
		.. " "
		.. sl_hl("StatusLineDim")
		.. table.concat(names, ", ")
end

---@return string
local diagnostic_component = function()
  local parts = {}
  for _, severity in ipairs({ "ERROR", "WARN" }) do
    local count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity[severity] })
    if count > 0 then
      local icon = icons.diagnostics[severity]
      table.insert(parts, sl_hl("Diagnostic" .. severity:sub(1,1) .. severity:sub(2):lower()) .. icon.symbol .. " " .. count)
    end
  end

  if #parts == 0 then
    return ""
  end

  return table.concat(parts, sl_hl("StatusLine") .. separators.compontent.left)
end

--- The buffer's filetype.
---@return string?
local file_component = function()
  local devicons = require("nvim-web-devicons")

  local buftype = vim.bo.buftype
  local ft = vim.bo.filetype

  local buf_path = vim.api.nvim_buf_get_name(0)
  local buf_name = vim.fn.fnamemodify(buf_path, ":t")
  local buf_ext = vim.fn.fnamemodify(buf_path, ":e")

  if ft == "" and buf_path == "" then
    return
  end

  local icon = (icons.ft[ft] or {}).symbol
  local icon_hl = (icons.ft[ft] or {}).group

  if not icon then
    icon, icon_hl = devicons.get_icon(buf_name, buf_ext)
  end

  if not icon then
    icon, icon_hl = devicons.get_icon_by_filetype(ft, { default = true })
  end

  local display_name = buf_name == "" and buf_path or buf_name
  return sl_hl(icon_hl) .. icon .. " " .. sl_hl("StatusLineBold") .. display_name
end

local file_percent_component = function()
  local cur = vim.fn.line(".") local total = vim.fn.line("$")
  local pct
  if cur == 1 then
    pct = "TOP"
  elseif cur == total then
    pct = "BOT"
  else
    pct = string.format("%2d%%%%", math.floor(cur / total * 100))
  end

  return sl_hl("StatusLineInvertedSep")
    .. separators.section.right
    .. sl_hl("StatusLineInverted")
    .. " " .. pct .. " "
    .. string.format("%2d:%-2d ", vim.fn.line("."), vim.fn.virtcol("."))
end

local time_component = function()
  return sl_hl("StatusLineInsertSep")
    .. separators.section.right
    .. sl_hl("StatusLineModeInsert")
    .. " " .. os.date("%R") .. " "
end

---@return string?
local modified_component = function()
  if vim.bo.modified then
    return sl_hl("StatusLineModified") .. "[+]"
  end
end

---@return string
local wordcount_component = function()
  local wc = vim.api.nvim_buf_call(0, vim.fn.wordcount)
  local visual = vim.fn.mode():match("^[vV\22]")

  return sl_hl("StatusLineDim")
    .. " "
    .. string.format("%s%sw", visual and wc.visual_words .. "/" or "", wc.words)
    .. " "
    .. string.format("%s%sc", visual and wc.visual_chars .. "/" or "", wc.chars)
    .. " "
end

function M.render()
  local win_is_active = tonumber(vim.g.actual_curwin) == vim.api.nvim_get_current_win()

  if not win_is_active then
    local file = file_component()
    return file and " " .. file or ""
  end

  local ft = vim.bo.filetype

  local left_components = {
    mode_component(),
    git_component(),
    diagnostic_component(),
    file_component(),
    modified_component(),
  }

  local center_components = {
    dap_component(),
    lsp_progress_component(),
  }

  local right_components = {
    ft == "markdown" and wordcount_component() or "",
    lsp_clients_component(),
    file_percent_component(),
    time_component()
  }

  local left = table.concat(
    vim.iter(left_components):filter(function(c) return c and c~= "" end):totable(),
    sl_hl("StatusLine") .. " "
  )

  local center = table.concat(
    vim.iter(center_components):filter(function(c) return c and c ~= "" end):totable(),
      sl_hl("StatusLine") .. " "
  )

  local right = table.concat(
    vim.iter(right_components):filter(function(c) return c and c ~= "" end):totable(),
      sl_hl("StatusLine") .. " "
  )

  return left
    .. sl_hl("StatusLine") .. " "
    .. "%="
    .. center
    .. "%="
    .. right
end


return M
