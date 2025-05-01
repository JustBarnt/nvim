---@class helpers.formatting
local M = {}

---@param diagnostic vim.Diagnostic
M.formatErrors = function(diagnostic)
  local msg = diagnostic.message
  if not msg:find "Argument of type" then
    return msg
  end

  -- Flatten TS Errors Messages
  msg = msg:gsub("\r", ""):gsub("\n", " ")

  -- Extract argument and parameter types
  local arg_type = msg:match "Argument of type%s+['\"]?([^'\"]+)['\"]?%s+is not assignable"
  local param_type = msg:match "parameter of type%s+['\"]?([^'\"]+)['\"]?"

  -- Prepare formatted output
  local formatted = { "Argument mismatch:" }

  if arg_type and param_type then
    table.insert(formatted, arg_type)
    table.insert(formatted, param_type)
  else
    table.insert(formatted, msg) -- fallback
  end

  -- Extract additional explanation lines
  local explanations = {}
  local start = msg:find "Types of parameters" or msg:find "Type '"
  if start then
    local trailing = msg:sub(start)
    for line in trailing:gmatch "[^%.]+%.?" do
      local trimmed = vim.trim(line)
      if trimmed ~= "" then
        table.insert(explanations, trimmed)
      end
    end
  end

  -- Add explanations
  for _, line in ipairs(explanations) do
    table.insert(formatted, line)
  end

  -- Append error code if available
  local code = msg:match "%[(%d+)%]" or diagnostic.code
  if code then
    table.insert(formatted, string.format("❗ [%s]", code))
  end

  return table.concat(formatted, "\n")
end

return M
