---@class lang
---@field bash modules.lsp.lang.bash
---@field cpp modules.lsp.lang.cpp
---@field git modules.lsp.lang.git
---@field go modules.lsp.lang.go
---@field js modules.lsp.lang.js
---@field lua modules.lsp.lang.lua
---@field php modules.lsp.lang.php
---@field py modules.lsp.lang.py
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

-- formatters_by_ft = vim.iter(Lang):fold(
--   {},
--   ---@param acc table
--   ---@param config LSPConfig
--   function(acc, _, config)
--     for _, ft in ipairs(config.filetypes) do
--       acc[ft] = config.formatters
--     end
--     return acc
--   end
-- ),

function M.get_formatters_by_ft()
  local ret = {}
  for key, value in pairs(M) do
    vim.iter(M[key]):fold(ret, function(acc, _, options)
      if vim.tbl_contains(options, "server") then
        for _, ft in ipairs(options.filetypes) do
          acc[ft] = options.formatters
        end
      end
    end)
  end
  return ret
end

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
