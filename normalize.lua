local M = {}
dofile("unicode-names.lua")
dofile('unicode-normalization.lua')
local NFC = unicode.conformance.toNFC
local char = unicode.utf8.char
local gmatch = unicode.utf8.gmatch
local name = unicode.conformance.name
local byte = unicode.utf8.byte
local unidata = characters.data

local function make_hash (t) 
  local y = {}
  for _,v in ipairs(t) do 
    y[v] = true
  end
  return y
end

local letter_categories = make_hash {"lu","ll","lt","lo","lm"}

local mark_categories = make_hash {"mn","mc","me"}

local function printchars(s)
	local t = {}
	for x in gmatch(s,".") do
		t[#t+1] = name(byte(x))
	end
	print(table.concat(t,":"))
end

local categories = {}


local function get_category(charcode)
  local category = categories[charcode] or unidata[charcode].category
  categories[charcode] = category
  return category
end

-- get glyph char and category
local function glyph_info(n)
  local char = n.char
  return char, get_category(char)
end

local function normalize_marks(head, n)
  print "máme mark"
  return head, n.next
end

local function normalize_glyphs(head, n)
  --local charcode = n.char
  --local category = get_category(charcode)
  local charcode, category = glyph_info(n)
  if letter_categories[category] then 
    local nextn = n.next
    if nextn.id == 37 then
      local nextchar = nextn.char
      local nextcat = get_category(nextchar)
      if mark_categories[nextcat] then
        return normalize_marks(head,n)
      end
    end
  end
  return head, n.next 
end


function M.nodes(head)
	local t = {}
	local text = false
  local n = head
	-- for n in node.traverse(head) do
  while n do
		if n.id == 37 then
      local charcode = n.char
			print(name(charcode))
			print(get_category(charcode))
			t[#t+1]= char(charcode)
			text = true
      head, n = normalize_glyphs(head, n)
		else
			if text then
				local s = table.concat(t)
				print(s)
				printchars(NFC(s))
				print("----------")
			end
			text = false
			t = {}
      n = n.next
		end
	end
	return head
end

return M
