local icons = require("utils.statusline-icons")

---@class utils.statusline
local M  = {}

-- ╭─────────────────────────────────────────────────────────╮
-- │ Types                                                   │
-- ╰─────────────────────────────────────────────────────────╯

---@class StatuslineSegment
---@field text string
---@field hl? string -- defaults to "StatusLine"

---@alias StatuslineComponent StatuslineSegment[]

-- ╭─────────────────────────────────────────────────────────╮
-- │ Helpers                                                 │
-- ╰─────────────────────────────────────────────────────────╯

local separators = {
  component = { left = "", right = "" },
  section = { left = "", right = "" },
  powerline = { left = "", right = "" },
}


---@param group string
---@return vim.api.keyset.get_hl_info
local get_hl = function(group)
  return vim.api.nvim_get_hl(0, { name = group, link = false, create = false })
end

---@param segments StatuslineSegment[]
---@return string
local serialize_segments = function(segments)
  local out = {}
  local current_hl = nil
  for _, seg in ipairs(segments) do
    local hl = seg.hl or "StatusLine"
    if hl ~= current_hl then
      table.insert(out, "%#" .. hl .. "#")
      current_hl = hl
    end
    table.insert(out, seg.text)
  end
  return table.concat(out)
end

---@param icon CustomIcon
---@return StatuslineSegment[]
local icon_segments = function(icon)
  return {
    { text = icon.symbol, hl = icon.group },
    { text = "",          hl = "StatusLine" }
  }
end

---@param items string[]
---@param hl?    string
---@return StatuslineSegment
local gen_component = function(items, hl)
  local text = ""
  hl = hl or "StatusLine"
  for _, item in pairs(items) do
    text = text .. item
  end
  return { text = text, hl = hl }
end

-- ╭─────────────────────────────────────────────────────────╮
-- │ Highlight Groups                                        │
-- ╰─────────────────────────────────────────────────────────╯

-- Mode name -> { bg color source group, bg color attribute }
-- These drive both the mode block AND the generated sep groups.
local mode_hl_sources = {
  Normal  = { group = "StatusLine",  attr = "fg"  },
  Pending = { group = "Comment",     attr = "fg"  },
  Visual  = { group = "SpecialKey",  attr = "fg"  },
  Insert  = { group = "diffAdded",   attr = "fg"  },
  Command = { group = "Number",      attr = "fg"  },
  Replace = { group = "Constant",    attr = "fg"  },
}

local set_hl_groups = function()
  local sl_bg = get_hl("StatusLine").bg
  local sl_fg = get_hl("StatusLine").fg

  ---@type table<string, vim.api.keyset.highlight>
  local groups = {
    StatusLineModeOther      = { link = "StatusLine" },
    StatusLineBold           = { bold = true },
    StatusLineDim            = { fg = get_hl("LineNr").fg },
    StatusLineDimItalic      = { fg = get_hl("LineNr").fg, italic = true },
    StatusLineInverted       = { fg = sl_bg, bg = sl_fg },
    StatusLineDiffAdded      = { fg = get_hl("diffAdded").fg },
    StatusLineDiffChanged    = { fg = get_hl("diffChanged").fg },
    StatusLineDiffRemoved    = { fg = get_hl("diffRemoved").fg },
    StatusLineInsertSep      = { fg = get_hl("diffAdded").fg, bg = sl_bg }
  }

  -- Generate mode block + sep groups from mode_hl_sources
  for mode_name, source in pairs(mode_hl_sources) do
    local mode_bg = get_hl(source.group)[source.attr]
    groups["StatusLineMode" .. mode_name] = { fg = sl_bg, bg = mode_bg }
    -- Sep group: arrow fg matches the mode block color, bg is the statusline bg
    groups["StatusLineMode" .. mode_name .. "Sep"] = { fg = mode_bg, bg = sl_bg }
  end

  for group, opts in pairs(groups) do
    vim.api.nvim_set_hl(0, group, opts)
  end
end

set_hl_groups()

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("barnt/statusline_colors", { clear = true }),
  desc = "Re-apply statusline highlights on colorscheme change",
  callback = set_hl_groups,
})

-- ╭─────────────────────────────────────────────────────────╮
-- │ Components                                              │
-- ╰─────────────────────────────────────────────────────────╯

---@return StatuslineComponent
local mode_component = function()
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

  local settings  = mode_settings[vim.api.nvim_get_mode().mode] or {}
  local mode      = settings.name or "UNKNOWN"
  local hl        = "StatusLineMode" .. (settings.hl or "Other")
  local hl_sep    = hl .. "Sep"

  return {
    gen_component({ " ", mode, " " }, hl),
    gen_component({ separators.powerline.left }, hl_sep),
  }
end

vim.api.nvim_create_autocmd("User", {
  pattern = "GitSignsUpdate",
  group = vim.api.nvim_create_augroup("barnt/statusline_gitsigns", { clear = true }),
  command = "redrawstatus"
})

---@return StatuslineComponent
local git_component = function()
  local head = vim.b.gitsigns_head
  if not head or head == "" then
    return {}
  end

  local segments = {}
  vim.list_extend(segments, icon_segments(icons.misc.branch))
  table.insert(segments, gen_component({ head, " " }))

  local dict = vim.b.gitsigns_status_dict
  local git_icons = Utils.ui.icons.git
  if dict then
    if (dict.added or 0) > 0 then
      table.insert(segments, gen_component({ git_icons.added, dict.added, " " }, "StatusLineDiffAdded"))
    end
    if (dict.changed or 0) > 0 then
      table.insert(segments, gen_component({ git_icons.modified, dict.changed, " " }, "StatusLineDiffChanged"))
    end
    if (dict.removed or 0) > 0 then
      table.insert(segments, gen_component({ git_icons.removed, dict.removed, " " }, "StatusLineDiffRemoved"))
    end
  end

  table.insert(segments, gen_component({ separators.component.left }))
  return segments
end

---@return StatuslineComponent
local diagnostic_component = function()
  local segments = {}

  for _, severity in ipairs({ "ERROR", "WARN" }) do
    local count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity[severity] })
    if count > 0 then
      local icon = icons.diagnostics[severity]
      local hl   = "Diagnostic" .. severity:sub(1, 1) .. severity:sub(2):lower()
      table.insert(segments, gen_component({ icon.symbol, tostring(count), " " }, hl))
    end
  end

  if #segments > 0 then
    table.insert(segments, gen_component({ separators.component.left }))
  end

  return segments
end

---@return StatuslineComponent
local file_component = function()
  local devicons = require("nvim-web-devicons")

  local ft       = vim.bo.filetype
  local buf_path = vim.api.nvim_buf_get_name(0)
  local buf_name = vim.fn.fnamemodify(buf_path, ":t")
  local buf_ext  = vim.fn.fnamemodify(buf_path, ":e")

  if ft == "" and buf_path == "" then
    return {}
  end

  local icon    = (icons.ft[ft] or {}).symbol
  local icon_hl = (icons.ft[ft] or {}).group

  if not icon then
    icon, icon_hl = devicons.get_icon(buf_name, buf_ext)
  end

  if not icon then
    icon, icon_hl = devicons.get_icon_by_filetype(ft, { default = true })
  end

  local display_name = buf_name == "" and buf_path or buf_name

  return {
    gen_component({ icon, " " }, icon_hl),
    gen_component({ display_name }, "StatusLineBold"),
  }
end

---@return StatuslineComponent
local dap_component = function()
  if not package.loaded["dap"] or require("dap").status() == "" then
    return {}
  end

  return {
    gen_component({ icons.misc.bug.symbol }, "Special"),
    gen_component({ "  ", require("dap").status() })
  }
end

---@type table<string, string?>
local progress_status = {
  client = nil,
  kind   = nil,
  title  = nil,
}

vim.api.nvim_create_autocmd("LspProgress", {
  group = vim.api.nvim_create_augroup("barnt/statusline", { clear = true }),
  desc = "Update LSP Progress in statusline",
  pattern = { "begin", "end" },
  callback = function(args)
    if not args.data then return end

    progress_status = {
      client = vim.lsp.get_client_by_id(args.data.client_id).name,
      kind   = args.data.params.value.kind,
      title  = args.data.params.value.title
    }

    if progress_status.kind == "end" then
      progress_status.title = nil
      vim.defer_fn(function()
        vim.api.nvim__redraw { statusline = true }
      end, 3000)
    else
      vim.api.nvim__redraw { statusline = true }
    end
  end
})

---@return StatuslineComponent
local lsp_progress_component = function()
  local invalid = not progress_status.client
    or not progress_status.title
    or vim.startswith(vim.api.nvim_get_mode().mode, "i")

  if invalid then
    return {}
  end

  local segments = {}
  vim.list_extend(segments, icon_segments(icons.misc.lsp))
  table.insert(segments, gen_component({ progress_status.client, ": " }, "StatusLineDim"))
  table.insert(segments, gen_component({ progress_status.title }, "StatusLineDimItalic"))
  return segments
end

---@return StatuslineComponent
local lsp_clients_component = function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    return {}
  end

  local names = vim.iter(clients):map(function(c) return c.name end):totable()
  local segments = {}
  vim.list_extend(segments, icon_segments(icons.misc.lsp))
  table.insert(segments, gen_component({ table.concat(names, ", ") }, "StatusLineDim"))
  return segments
end

---@return StatuslineComponent
local file_percent_component = function()
  local cur   = vim.fn.line(".")
  local total = vim.fn.line("$")
  local pct

  if cur == 1 then
    pct = "TOP"
  elseif cur == total then
    pct = "BOT"
  else
    pct = string.format("%2d%%%%", math.floor(cur / total * 100))
  end

  local pos = string.format("%2d:%-2d", vim.fn.line("."), vim.fn.virtcol("."))

  return {
    gen_component({ separators.component.right }),
    gen_component({ " ", pct, " ", pos, " " }, "StatusLineBold"),
  }
end

---@return StatuslineComponent
local time_component = function()
  local settings  = mode_hl_sources[vim.api.nvim_get_mode().mode] -- intentionally nil for most modes
  -- Reuse whatever the current mode color is for the right-side cap
  local cur_mode  = vim.api.nvim_get_mode().mode
  -- stylua: ignore start
  local mode_map  = {
    n = "Normal", no = "Pending", nov = "Pending", ["no\22"] = "Pending",
    v = "Visual", V = "Visual", ["\22"] = "Visual",
    i = "Insert", ic = "Insert", ix = "Insert",
    R = "Replace", Rv = "Replace",
    c = "Command", cv = "Command", t = "Command",
  }
  -- stylua: ignore end
  local hl_key    = mode_map[cur_mode] or "Normal"
  local hl        = "StatusLineMode" .. hl_key
  local hl_sep    = hl .. "Sep"

  return {
    gen_component({ separators.powerline.right }, hl_sep),
    gen_component({ "  ", tostring(os.date("%R")), " " }, hl),
  }
end

---@return StatuslineComponent
local modified_component = function()
  if not vim.bo.modified then
    return {}
  end
  return {
    gen_component({ " [+]" }, "StatusLineDiffAdded")
  }
end

---@return StatuslineComponent
local wordcount_component = function()
  local wc     = vim.api.nvim_buf_call(0, vim.fn.wordcount)
  local visual = vim.fn.mode():match("^[vV\22]")

  return {
    gen_component({
      string.format(" %s%sw %s%sc ",
        visual and wc.visual_words .. "/" or "", wc.words,
        visual and wc.visual_chars .. "/" or "", wc.chars),
    }, "StatusLineDim")
  }
end

-- ╭─────────────────────────────────────────────────────────╮
-- │ Render                                                  │
-- ╰─────────────────────────────────────────────────────────╯

---@param groups StatuslineComponent[]
---@return string
local render_section = function(groups)
  local segments = {}
  for _, component in ipairs(groups) do
    if #component > 0 then
      if #segments > 0 then
        table.insert(segments, gen_component({ " " }))
      end
      vim.list_extend(segments, component)
    end
  end
  return serialize_segments(segments)
end

function M.render()
  local win_is_active = tonumber(vim.g.actual_curwin) == vim.api.nvim_get_current_win()

  if not win_is_active then
    local file = file_component()
    return #file > 0 and " " .. serialize_segments(file) or ""
  end

  local ft = vim.bo.filetype

  local left = render_section({
    mode_component(),
    git_component(),
    diagnostic_component(),
    file_component(),
    modified_component(),
  })

  local center = render_section({
    dap_component(),
    lsp_progress_component(),
  })

  local right = render_section({
    ft == "markdown" and wordcount_component() or {},
    lsp_clients_component(),
    file_percent_component(),
    time_component(),
  })

  return left .. "%#StatusLine# %=" .. center .. "%=" .. right
end

return M
