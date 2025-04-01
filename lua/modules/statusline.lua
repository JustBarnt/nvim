local get_opt = vim.api.nvim_get_option_value
local icons = Helpers.ui.icons

local Statusline = {}

-- see https://vimhelp.org/options.txt.html#%27statusline%27 for part fmt strs
local stl_parts = {
  mode = nil,
  buf_info = nil,
  diag = nil,
  git_info = nil,
  modifiable = nil,
  modified = nil,
  pad = " ",
  path = nil,
  ro = nil,
  scrollbar = nil,
  sep = "%=",
  trunc = "%<",
  lsp = nil,
  datetime = nil,
}

local stl_order = {
  "pad",
  "path",
  "mod",
  "ro",
  "sep",
  "diag",
  "sep",
  "lsp",
  "sep",
  "fileinfo",
  "pad",
  "scrollbar",
  "pad",
  "sep",
  "datetime",
}

local ui_icons = {
  ["branch"] = { "DiagnosticOk", icons.misc["branch"] },
  ["file"] = { "NonText", icons.misc["file"] },
  ["fileinfo"] = { "DiagnosticInfo", icons.misc["hamburger"] },
  ["nomodifiable"] = { "DiagnosticWarn", icons.misc["bullet"] },
  ["modified"] = { "DiagnosticError", icons.misc["bullet"] },
  ["readonly"] = { "DiagnosticWarn", icons.misc["lock"] },
  ["error"] = { "DiagnosticError", icons.diagnostics["Error"] },
  ["warn"] = { "diagnosticwarn", icons.diagnostics["Warn"] },
}

local function hl_icons(icon_list)
  local hl_syms = {}
  for name, list in pairs(icon_list) do
    hl_syms[name] = Helpers.ui.hl_str(list[1], list[2])
  end
  return hl_syms
end

-- Get fmt strs from dict and concatenate them into one string
local function ordered_tbl_concat(order_tbl, stl_part_tbl)
  local str_table = {}
  local part = nil

  for _, val in ipairs(order_tbl) do
    part = stl_part_tbl[val]
    if part then
      table.insert(str_table, part)
    end
  end
  return table.concat(str_table, " ")
end

local hl_ui_icons = hl_icons(ui_icons)

local function escape_str(str)
  local output = str:gsub("([%(%)%%%+%-%*%?%[%]%^%$])", "%%%1")
  return output
end

--Path/Git Widget
function Statusline.get_path_info(root, fname, icon_tbl)
  local file_name = vim.fn.fnamemodify(fname, ":t")

  local file_icon, icon_hl = require("mini.icons").get("file", file_name)
  file_icon = file_name ~= "" and Helpers.ui.hl_str(icon_hl, file_icon) or ""

  local file_icon_name = table.concat({ file_icon, file_name })

  if vim.bo.buftype == "help" then
    return table.concat({ icon_tbl["file"], file_icon_name })
  end

  local remote = Helpers.root.get_git_remote(root)
  local branch = Helpers.root.get_git_branch(root)
  local dir_path = vim.fn.fnamemodify(fname, ":h") .. "/"

  local win_width = vim.api.nvim_win_get_width(0)
  local dir_threshold_width = 15
  local repo_threshold_width = 10

  local repo_info = ""
  if remote and branch then
    dir_path = string.gsub(dir_path, "^" .. escape_str(root) .. "/", "")
    repo_info = table.concat({
      icon_tbl["branch"],
      " ",
      remote,
      ":",
      branch,
      " ",
    })
  end

  dir_path = win_width >= dir_threshold_width + #repo_info + #dir_path + #file_icon_name and dir_path or ""
  repo_info = win_width >= repo_threshold_width + #repo_info + #file_icon_name and repo_info or ""

  return table.concat({ repo_info, icon_tbl["file"], dir_path, file_icon_name })
end

function Statusline.get_diag_str()
  if not Helpers.lsp.SupportsMethod("textDocument/publishDiagnostics") then
    return ""
  end

  local diag_tbl = {}
  local total = vim.diagnostic.count()
  local errs = total[1] or 0
  local warns = total[2] or 0

  vim.list_extend(diag_tbl, { hl_ui_icons["error"], " ", Helpers.ui.pad_str(tostring(errs), 3, "left"), " " })
  vim.list_extend(diag_tbl, { hl_ui_icons["warn"], " ", Helpers.ui.pad_str(tostring(warns), 3, "left"), " " })

  return table.concat(diag_tbl)
end

function Statusline.get_vlinecount_str()
  local raw_count = vim.fn.line(".") - vim.fn.line("v")
  raw_count = raw_count < 0 and raw_count - 1 or raw_count + 1
  return Helpers.ui.group_number(math.abs(raw_count), ",")
end

local non_program_modes = {
  ["markdown"] = true,
  ["text"] = true,
  ["log"] = true,
}

function Statusline.get_fileinfo_widet(icon_tbl)
  local ft = get_opt("filetype", {})
  local lines = Helpers.ui.group_number(vim.api.nvim_buf_line_count(0), ",")

  if not non_program_modes[ft] then
    return table.concat({ icon_tbl.fileinfo, " ", lines, " lines" })
  end

  local wc_table = vim.fn.wordcount()
  if not wc_table.visual_words or not wc_table.visual_chars then
    return table.concat({
      icon_tbl.fileinfo,
      " ",
      lines,
      " lines  ",
      Helpers.ui.group_number(wc_table.words, ",")(" words "),
    })
  else
    return table.concat({
      Helpers.ui.hl_str("DiagnosticInfo", "‹›"),
      " ",
      Statusline.get_vlinecount_str(),
      " lines  ",
      Helpers.ui.group_number(wc_table.visual_words, ","),
      " words  ",
      Helpers.ui.group_number(wc_table.visual_chars, ","),
      " chars",
    })
  end
end

function Statusline.get_active_lsps()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  local names = {}
  for _, client in ipairs(clients) do
    table.insert(names, client.name)
  end

  if #names > 0 then
    return string.format("%s: %s", icons.misc.lsp, table.concat(names, "|"))
  else
    return nil
  end
end

function Statusline.get_scrollbar()
  local sbar_chars = {
    "▔",
    "🮂",
    "🬂",
    "🮃",
    "▀",
    "▄",
    "▃",
    "🬭",
    "▂",
    "▁",
  }

  local cur_line = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_line_count(0)

  local i = math.floor((cur_line - 1) / lines * #sbar_chars) + 1
  local sbar = string.rep(sbar_chars[i], 2)

  return Helpers.ui.hl_str("Substitute", sbar)
end

function Statusline.datetime()
  return " " .. os.date("%R")
end

function Statusline.render()
  local fname = vim.api.nvim_buf_get_name(0)
  local root = nil
  local filetype = get_opt("filetype", { buf = 0 })

  if filetype == "snacks_dashboard" then
    return ""
  end

  if vim.bo.buftype == "terminal" or vim.bo.buftype == "nofile" or vim.bo.buftype == "prompt" then
    fname = vim.bo.ft
  else
    root = Helpers.root.get({ normalize = true })
  end

  local buf_num = vim.api.nvim_win_get_buf(vim.g.statusline_winid)

  -- left
  stl_parts["mode"] = Helpers.mode.get_mode()
  stl_parts["path"] = Statusline.get_path_info(root, fname, hl_ui_icons)
  stl_parts["ro"] = get_opt("readonly", { buf = buf_num }) and hl_ui_icons["readonly"] or ""
  stl_parts["diag"] = Statusline.get_diag_str()
  if not get_opt("modifiable", { buf = buf_num }) then
    stl_parts["mod"] = hl_ui_icons["modifiable"]
  elseif get_opt("modified", { buf = buf_num }) then
    stl_parts["mod"] = hl_ui_icons["modified"]
  else
    stl_parts["mod"] = " "
  end

  -- right
  stl_parts["lsp"] = Statusline.get_active_lsps()
  stl_parts["fileinfo"] = Statusline.get_fileinfo_widet(hl_ui_icons)
  stl_parts["datetime"] = Statusline.datetime()

  return ordered_tbl_concat(stl_order, stl_parts)
end

return Statusline
