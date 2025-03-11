--- Adds a split method to the string class
function string:split(sep)
  local sep = sep or "%s"  -- default to whitespace if no separator provided
  local t = {}
  for substring in self:gmatch("([^" .. sep .. "]+)") do
    table.insert(t, substring)
  end
  return t
end

return string
