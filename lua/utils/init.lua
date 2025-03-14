local M = {}

--- returns a list of tables containing the servers from each language configuration
---@param path string
---@param key string
---@return string[][]
function M.get_ensured_installed(path, key)
  local lang_paths = vim.fn.globpath(path, "*.lua", false, true)
  local langs = {}
  local ret = {}
  for _, lang in ipairs(lang_paths) do
    table.insert(langs, vim.fn.fnamemodify(lang, ":t:r"))
  end

  for _, lang in ipairs(langs) do
    local success, obj = pcall(require, path .. "/" .. lang)
    if success then
      table.insert(ret, obj[key])
    end
  end
  return ret
end

---@generic T
---@param list T[]
---@return T[]
function M.dedup(list)
  local ret = {}
  local seen = {}
  for _, v in ipairs(list) do
    if not seen[v] then
      table.insert(ret, v)
      seen[v] = true
    end
  end
  return ret
end

--- builds a table from n tables given and removes any duplicates it finds and returns a merged table
---@param ... string[]
---@return string[]
function M.build_table(...)
  --- Flatten our n tables in to a single list
  ---@type string[]
  local list = vim.iter({...}):flatten(math.huge):totable()
  return M.dedup(list)
end

return M
