---@class lang
---@field bash modules.lsp.lang.bash
---@field cmake modules.lsp.lang.cmake
---@field cpp modules.lsp.lang.cpp
---@field git modules.lsp.lang.git
---@field go modules.lsp.lang.go
---@field js modules.lsp.lang.js
---@field lua modules.lsp.lang.lua
---@field php modules.lsp.lang.php
---@field svelte modules.lsp.lang.svelte
local M = {}

setmetatable(M, {
  __index = function(self, key)
    local mod = require("modules.lsp.lang." .. key)
    local result = {}
    for k, v in pairs(mod) do
      if k ~= key then
        result[k] = v
      end
    end
    if type(mod[key]) == "table" then
      for k, v in pairs(mod[key]) do
        result[k] = v
      end
    end

    local mt = getmetatable(mod)
    if mt then
      setmetatable(result, mt)
    end
    rawset(self, key, result)
    return result
  end,
})

---@param option string
---@return string[]
function M.get_option(option)
  local ret = {}
  for key, _ in pairs(M) do
    if type(M[key]) ~= "function" then
      table.insert(ret, M[key][option] or vim.empty_dict())
    end
  end
  return Helpers.build_table(ret)
end

return M
