local api = vim.api
local DataFlow = {}
local ns = api.nvim_create_namespace('dataflow_highlights')

local log_file = vim.fn.stdpath('cache') .. '/dataflow.log'
local function log(...)
  local args = {...}
  local msg = table.concat(vim.tbl_map(function(v)
    if type(v) == 'table' then
      return vim.inspect(v)
    end
    return tostring(v)
  end, args), ' ')
  local file = io.open(log_file, 'a')
  if file then
    file:write(os.date('%Y-%m-%d %H:%M:%S') .. ' - ' .. msg .. '\n')
    file:close()
  end
end

local file = io.open(log_file, "w")
if file then
  file:write('=== DataFlow Log Started ===\n')
  file:close()
end

log("Log file location:", log_file)

local function hex_to_rgb(hex)
  return {
    r = bit.rshift(bit.band(hex, 0xFF0000),16),
    g = bit.rshift(bit.band(hex, 0x00FF00), 8),
    b = bit.band(hex, 0x0000FF)
  }
end

local function blend_colors(fg, bg, alpha)
  if not fg or not bg then
    return '#5C6370'
  end

  local fg_rgb = hex_to_rgb(fg)
  local bg_rgb = hex_to_rgb(bg)

  local r = math.floor(fg_rgb.r * alpha + bg_rgb.r * (1-alpha))
  local g = math.floor(fg_rgb.g * alpha + bg_rgb.g * (1-alpha))
  local b = math.floor(fg_rgb.b * alpha + bg_rgb.b * (1-alpha))
  return string.format('#%02x%02x%02x', r, g, b)
end

---@param alpha integer
local function create_dimmed_color(alpha)
  local normal_hl = api.nvim_get_hl(0, { name = "Normal" })
  local bg_color = normal_hl.bg
  local fg_color = normal_hl.fg

  return blend_colors(fg_color, bg_color, alpha)
end

-- BUG: When cursor is on the method/function name it shows just the function name
--      and dims everything in the function block

---@param client vim.lsp.Client
function DataFlow.highlight_variable_flow(client)
  log("=== Starting highlight_variable_flow ===")
  
  -- Clear previous highlights
  api.nvim_buf_clear_namespace(0, ns, 0, -1)

  local current_word = vim.fn.expand('<cword>')
  log("Current word:", current_word)
  
  if current_word == '' or current_word:match('^%s*$') then
    log("No word under cursor or whitespace only")
    return
  end

  local win = api.nvim_get_current_win()
  log("Window:", win)
  log("Client name:", client.name)
  log("Client offset encoding:", client.offset_encoding)

  ---@class lsp.TextDocumentPositionParams
  local params = vim.lsp.util.make_position_params(win, client.offset_encoding)
  log("Params:", params)

  if not params then
    log("ERROR: make_position_params returned nil")
    return
  end

  params.context = { includeDeclaration = true }
  log("Sending textDocument/references request...")

  vim.lsp.buf_request(0, "textDocument/references", params, function(err, res, ctx) 
    log("=== LSP Response ===")
    log("Error:", err)
    log("Result type:", type(res))
    log("Result:", res)
    log("Context:", ctx)
    
    if err then
      log("ERROR: LSP returned error")
      return
    end
    
    if not res then
      log("ERROR: Result is nil")
      return
    end
    
    log("Found", #res, "references")

    -- Get current function range with treesitter
    local ts_utils = require("nvim-treesitter.ts_utils")
    local current_node = ts_utils.get_node_at_cursor()
    log("Current node:", current_node and current_node:type() or "nil")

    if not current_node then
      log("ERROR: No current node from treesitter")
      return
    end

    local fn_node = current_node

    local depth = 0
    while fn_node and depth < 50 do
      local node_type = fn_node:type()
      log("Checking node type:", node_type)

      if node_type:match('comment') or node_type:match('string') then
        log("Node is comment or string, returning")
        return
      end

      if node_type:match('function') or node_type:match('method') or 
        node_type:match('closure') or node_type:match('block') then
        log("Found function node:", node_type)
        break
      end
      fn_node = fn_node:parent()
      depth = depth + 1
    end

    if not fn_node then
      log("ERROR: No function node found")
      return
    end

    local srow, _, erow, _ = fn_node:range()
    log("Function range:", srow, "to", erow)
    
    local lines = {}

    for i, ref in ipairs(res) do
      log("Reference", i, "at line:", ref.range.start.line)
      lines[ref.range.start.line] = true
    end

    log("Dimming lines...")
    local dimmed_count = 0
    for line = srow, erow do
      if not lines[line] then
        log("Dimming line:", line)
        api.nvim_buf_set_extmark(0, ns, line, 0, {
          end_row = line + 1,
          end_col = 0,
          hl_group = 'DataFlowDim',
          hl_eol = true,
          priority = 200,
          hl_mode = 'replace'
        })
        dimmed_count = dimmed_count + 1
      else
        log("Keeping line active:", line)
      end
    end
    log("=== Done - dimmed", dimmed_count, "lines ===")
  end)
end

---@param client vim.lsp.Client
function DataFlow.setup(client)
  local group = api.nvim_create_augroup("DataFlow", { clear = true })

  local dimmed_color = create_dimmed_color(0.4)
  api.nvim_set_hl(0, "DataFlowDim", {
    fg = dimmed_color
    -- italic = true
  })

  api.nvim_create_autocmd({"CursorHold", "CursorHoldI"}, {
    group = group,
    callback = function()
      DataFlow.highlight_variable_flow(client)
    end,
  })

  api.nvim_create_autocmd({"CursorMoved", "CursorMovedI"}, {
    group = group,
    callback = function()
      api.nvim_buf_clear_namespace(0, ns, 0, -1)
    end,
  })

  vim.opt.updatetime = 300
end

return DataFlow
