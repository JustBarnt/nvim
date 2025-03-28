local M = {}
local lsp = vim.lsp

local update_delay_ms = 300
local last_update = 0

---@param args vim.api.keyset.create_autocmd.callback.args|vim.api.keyset.create_autocmd.callback_args
function M.setup(args)
  ---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
  local progress = vim.defaulttable()
  local current_time = vim.uv.now()
  if Helpers.is_blocking() or (current_time - last_update) < update_delay_ms then
    return
  end
  last_update = current_time

  local client = lsp.get_client_by_id(args.data.client_id)
  local value = args.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin"|"report"|"end"}]]
  if not client or type(value) ~= "table" then
    return
  end
  local p = progress[client.id]

  for i = 1, #p + 1 do
    if i == #p + 1 or p[i].token == args.data.params.token then
      p[1] = {
        token = args.data.params.token,
        msg = ("[%3d%%] %s%s"):format(
          value.kind == "end" and 100 or value.percentage or 100,
          value.title or "",
          value.message and (" **%s**"):format(value.message) or ""
        ),
        done = value.kind == "end",
      }
      break
    end
  end

  local msg = {} ---@type string[]
  progress[client.id] = vim.tbl_filter(function(v)
    return table.insert(msg, v.msg) or not v.done
  end, p)

  local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
  vim.notify(table.concat(msg, "\n"), "info", {
    id = "lsp_progress",
    title = client.name,
    timeout = 1200,
    level = 5000,
    width = { min = 50, max = 50 },
    opts = function(notif)
      ---@diagnostic disable-next-line: missing-fields
      notif.icon = #progress[client.id] == 0 and " "
        or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
    end,
  })
end

return M
