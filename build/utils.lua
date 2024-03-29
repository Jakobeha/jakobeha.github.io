local M = {}

local json = require("json")
local markdown = require("markdown")

M.log = function(...)
  io.stderr:write(string.format(...))
  io.stderr:write("\n")
end

M.dump = function(value)
  return json.stringify(value)
end

M.array_contains = function(items, test)
  for _, item in ipairs(items) do
    if item == test then
      return true
    end
  end
  return false
end

M.array_assoc = function(items, key)
  for k, v in M.opairs(items) do
    if k == key then
      return v
    end
  end
  return nil
end

M.clone_table = function(table)
  local table2 = {}
  for k,v in pairs(table) do
    table2[k] = v
  end
  return table2
end

M.append = function(dst, src)
  local len = #dst
  for i,x in ipairs(src) do
    dst[len + i] = x
  end
end

M.opairs = function(array_of_pairs)
  local i = 0
  return function()
    i = i + 1
    if i <= #array_of_pairs then
      return array_of_pairs[i][1], array_of_pairs[i][2]
    end
  end
end

M.unescape_string = function(string)
  return string:gsub("\\n", "\n"):gsub("\\t", "\t"):gsub("\\\"", "\""):gsub("\\'", "'"):gsub("\\ ", "\\")
end

-- https://stackoverflow.com/questions/1426954/split-string-in-lua
M.split_string = function(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t={}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end

M.read_file = function(path)
  local file = io.open(path, "rb") -- r read mode and b binary mode
  if not file then
    error("Could not open file " .. path)
  end
  local content = file:read "*a" -- *a or *all reads the whole file
  file:close()
  return content
end

M.write_file = function(path, content)
  local file = io.open(path, "wb")
  if not file then
    error("Could not open file for writing " .. path)
  end
  file:write(content)
  file:close()
end

M.read_json = function(path)
  local content = M.read_file(path)
  return json.parse(content)
end

M.parse_json = function(content)
  return json.parse(content)
end

M.markdown_to_html = function(md)
  local html, err = markdown(md)
  if not html then
    error("Could not render markdown: " .. err)
  end
  return html
end

M.get_site_dir = function()
  if arg and arg[1] then
    return arg[1]
  else
    return "../site"
  end
end

M.get_dist_dir = function()
  if arg and arg[2] then
    return arg[2]
  else
    return "../dist"
  end
end

return M
