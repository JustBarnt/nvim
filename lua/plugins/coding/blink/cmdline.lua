---@module 'blink-cmp'
---@class blink.cmp.CmdlineConfig --Partial
return {
  enabled = true,
  ---@diagnostic disable-next-line: assign-type-mismatch
  sources = function()
    local type = vim.fn.getcmdtype()
    if type == "/" or type == "?" then
      return { "buffer" }
    end
    if type == ":" or type == "@" then
      return { "cmdline", "path" }
    end
    return {}
  end,
  completion = {
    menu = { auto_show = true },
    ghost_text = { enabled = false },
  },
}
