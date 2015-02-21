local M = {}
dofile("unicode-names.lua")
dofile('unicode-normalization.lua')
local NFC = unicode.conformance.toNFC
local char = unicode.utf8.char
local gmatch = unicode.utf8.gmatch
local name = unicode.conformance.name
local byte = unicode.utf8.byte
local unidata = characters.data

local function make_hash = function(t) 
  local y = {}
  for _,v in ipairs(t) do 
    y[v] = true
  end
  return y
end

local letter_categories = 
local function printchars(s)
	local t = {}
	for x in gmatch(s,".") do
		t[#t+1] = name(byte(x))
	end
	print(table.concat(t,":"))
end

function M.nodes(head)
	local t = {}
	local text = false
	for n in node.traverse(head) do
		if n.id == 37 then
			print(name(n.char))
			print(unidata[n.char].category)
			t[#t+1]= char(n.char)
			text = true
		else
			if text then
				local s = table.concat(t)
				print(s)
				printchars(NFC(s))
				print("----------")
			end
			text = false
			t = {}
		end
	end
	return head
end

return M
