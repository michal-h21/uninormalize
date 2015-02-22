local M = {}
dofile("unicode-names.lua")
dofile('unicode-normalization.lua')
local NFC = unicode.conformance.toNFC
local char = unicode.utf8.char
local gmatch = unicode.utf8.gmatch
local name = unicode.conformance.name
local byte = unicode.utf8.byte
local unidata = characters.data
local length = unicode.utf8.len

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

local function get_mark(n)
  if n.id == 37 then
    local character, cat = glyph_info(n)
    if mark_categories[cat] then
      return char(character)
    end
  end
  return false
end

local function make_glyphs(head, nextn,s, lang, font, subtype) 
  local g = function(a) 
    local new_n = node.new(37, subtype)
    new_n.lang = lang
    new_n.font = font
    new_n.char = byte(a)
    return new_n
  end
  if length(s) == 1 then
    return node.insert_before(head, nextn,g(s))
  else
    local t = {}
    local first = true
    for x in gmatch(s,".") do
      print("multi znak",x)
        head, newn = node.insert_before(head, nextn, g(x))
    end
    return head
  end
end

local function normalize_marks(head, n)
  local lang, font, subtype = n.lang, n.font, n.subtype
  local text = {}
  text[#text+1] = char(n.char)
  local head, nextn = node.remove(head, n)
  --local nextn = n.next
  local info = get_mark(nextn)
  while(info) do
    text[#text+1] = info
    head, nextn = node.remove(head,nextn)
    info = get_mark(nextn)
  end
  local s = NFC(table.concat(text))
  print("máme mark: " .. s)
  local new_n = node.new(37, subtype)
  new_n.lang = lang
  new_n.font = font
  new_n.char = byte(s)
  --head, new_n = node.insert_before(head, nextn, new_n)
  -- head, new_n = node.insert_before(head, nextn, make_glyphs(s, lang, font, subtype))
  head, new_n = make_glyphs(head, nextn, s, lang, font, subtype)
  local t = {}
  for x in node.traverse_id(37,head) do
    t[#t+1] = char(x.char)
  end
  print("tak co? ", table.concat(t,":"), table.concat(text,";"), char(byte(s)),length(s))
  return head, nextn
end

local function normalize_glyphs(head, n)
  --local charcode = n.char
  --local category = get_category(charcode)
  local charcode, category = glyph_info(n)
  if letter_categories[category] then 
    local nextn = n.next
    if nextn.id == 37 then
      --local nextchar = nextn.char
      --local nextcat = get_category(nextchar)
      local nextchar, nextcat = glyph_info(nextn)
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
				--printchars(NFC(s))
				print("----------")
			end
			text = false
			t = {}
      n = n.next
		end
	end
	return head
end

local unibytes = {}

local function get_charcategory(s)
  local s = s or ""
  local b = unibytes[s] or byte(s) or 0
  unibytes[s] = b
  return get_category(b)
end

local function normalize_charmarks(t,i)
  local c = {t[i]}
  local i = i + 1
  local s = get_charcategory(t[i])
  while mark_categories[s] do
    c[#c+1] = t[i]
    i = i + 1
    s = get_charcategory(t[i])
  end
  return NFC(table.concat(c)), i
end

local function normalize_char(t,i)
  local ch = t[i]
  local c = get_charcategory(ch)
  if letter_categories[c] then
    local nextc = get_charcategory(t[i+1])
    if mark_categories[nextc] then
      return normalize_charmarks(t,i)
    end
  end
  return ch, i+1
end

function M.buffer(line)
  local t = {}
  local new_t = {}
  -- we need to make table witl all uni chars on the line
  for x in gmatch(line,".") do
    t[#t+1] = x
  end
  local i = 1
  -- normalize next char
  local c, i = normalize_char(t, i)
  new_t[#new_t+1] = c
  while t[i] do
    c, i = normalize_char(t,i)
    -- local  c = t[i]
    -- i =  i + 1
    new_t[#new_t+1] = c
  end
  return table.concat(new_t)
end
  

return M
