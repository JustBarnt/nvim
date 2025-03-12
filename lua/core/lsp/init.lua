local lsp_methods = vim.lsp.protocol.Methods
local methods = require("core.lsp.configured_methods")

for _, file in ipairs(vim.fn.globpath("lsp", "*.lua", false, true)) do
	local basepath = vim.fn.fnamemodify(file, ":t:r")
	vim.lsp.enable(basepath)
end

-- a wrapper around client:supports_method for LSP capabilities
---@param client vim.lsp.Client
---@param method vim.lsp.protocol.Method
---@param bufnr? integer Some LSP's support methods in specific files
---@return boolean
local function client_supports_method(client, method, bufnr)
	return client:supports_method(method, bufnr)
end


vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user-lsp-attach", { clear = true }),
  callback = function(ev)
		-- Attach generic LSP keymaps here
		local config = require("core.lsp.utils")
		require("core.keymaps.lsp").LspKeys(ev)

		-- Setup all potential lsp methods supported by the lsp	
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client then
			for _, method in pairs(lsp_methods) do
				---@diagnostic disable-next-line param-type-mismatch
				if client_supports_method(client, method, ev.buf) and methods[method] then
					-- Sets up any configured LSP Protocol Methods
					methods[method](ev)
				end
			end
		end
	end
})

---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
local progress = vim.defaulttable()

vim.api.nvim_create_autocmd("LspProgress", {
  ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
    if not client or type(value) ~= "table" then
      return
    end
    local p = progress[client.id]

    for i = 1, #p + 1 do
      if i == #p + 1 or p[i].token == ev.data.params.token then
        p[i] = {
          token = ev.data.params.token,
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
    vim.notify(table.concat(msg, "\n"), vim.log.levels.INFO, {
      id = "lsp_progress",
      title = client.name,
      opts = function(notif)
        notif.icon = #progress[client.id] == 0 and " "
          or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
      end,
    })
  end,
})
