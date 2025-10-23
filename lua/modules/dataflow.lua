local api = vim.api
local DataFlow = {}
local ns = api.nvim_create_namespace('dataflow_highlights')

function DataFlow.highlight_variable_flow()
  -- Clear previous highlights
  api.nvim_buf_clear_namespace(0, ns, 0, -1)

  local current_word = vim.fn.expand('<cword>')
  if current_word == '' then return end

  local win = api.nvim_get_current_win()
  local params = vim.lsp.util.make_position_params(win, 'utf-8')

  vim.lsp.buf_request(0, "textDocument/references", params, function(err, res, ctx) 
    if not res or vim.tbl_isempty(res) then return end

    -- Get current function range with treesitter
    local ts_utils = require("nvim-treesitter.ts_utils")
    local current_node = ts_utils.get_node_at_cursor()

    local fn_node = current_node
    -- Find enclosing function node
    while fn_node do
      local node_type = fn_node:type()
      if node_type:match('function') or node_type:match('method') or 
        node_type:match('closure') or node_type:match('block') then
        break
      end
      fn_node = fn_node:parent()
    end

    if not fn_node then return end

    -- get our start and end rows for the node
    local srow, _, erow, _ = fn_node:range()
    local lines = {}

    for _, ref in ipairs(res) do
      lines[ref.range.start.line] = true
    end

    vim.inspect(lines)

    -- dim all lines except reference line
    for line = srow, erow do
      if not lines[line] then
        api.nvim_buf_set_extmark(0, ns, line, 0, {
          end_row = line + 1,
          hl_group = 'Comment',
          hl_eol = true,
          prioirty = 100
        })
      end
    end
  end)
end

function DataFlow.setup()
  local group = api.nvim_create_augroup("DataFlow", { clear = true })

  api.nvim_create_autocmd({"CursorHold", "CursorHoldI"}, {
    group = group,
    callback = function()
      DataFlow.highlight_variable_flow()
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
