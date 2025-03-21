local M = {}
local lsp = vim.lsp
local api = vim.api

function M.setup()
  api.nvim_create_user_command("LspStop", function(kwargs)
    local name = kwargs.fargs[1]
    for _, client in ipairs(lsp.get_clients({ name = name })) do
      client:stop()
    end
  end, {
    nargs = "?",
    complete = function()
      return vim.tbl_map(function(c)
        return c.name
      end, lsp.get_clients())
    end,
  })

  api.nvim_create_user_command("LspRestart", function(kwargs)
    local name = kwargs.fargs[1]
    for _, client in ipairs(lsp.get_clients({ name = name })) do
      local bufs = lsp.get_buffers_by_client_id(client.id)
      client:stop()
      vim.wait(30000, function()
        return lsp.get_client_by_id(client.id) == nil
      end)
      local client_id = lsp.start(client.config, { attach = nil })
      if client_id then
        for _, buf in ipairs(bufs) do
          lsp.buf_attach_client(buf, client_id)
        end
      end
    end
  end, {
    nargs = "?",
    complete = function()
      return vim.tbl_map(function(c)
        return c.name
      end, lsp.get_clients())
    end,
  })
end

return M
