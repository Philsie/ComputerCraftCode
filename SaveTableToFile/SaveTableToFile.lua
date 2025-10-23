function saveTableToFile(tbl, filename)
  local function serialize(tbl, indent)
    indent = indent or ""
    local nextIndent = indent .. "  "
    local result = "{\n"
    for k, v in pairs(tbl) do
      local key
      if type(k) == "string" and k:match("^%a[%w_]*$") then
        key = k -- simple string keys can be used as identifiers
      else
        key = "[" .. (type(k) == "string" and string.format("%q", k) or tostring(k)) .. "]"
      end

      local value
      if type(v) == "table" then
        value = serialize(v, nextIndent)
      elseif type(v) == "string" then
        value = string.format("%q", v)
      else
        value = tostring(v)
      end

      result = result .. nextIndent .. key .. " = " .. value .. ",\n"
    end
    result = result .. indent .. "}"
    return result
  end

  local file = io.open(filename, "w")
  if not file then
    return false, "Cannot open file " .. filename
  end
  file:write("return " .. serialize(tbl))
  file:close()
  return true
end

-- Usage:
local myTable = component.me_controller.getFluidsInNetwork()  -- Function Producing the Table
local success, err = saveTableToFile(myTable, "output.txt")
if not success then
  print("Error saving file:", err)
else
  print("Table saved to output.txt")
end