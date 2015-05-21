local unicharacters = {}


if not characters then dofile('char-def.lua') end
--if not characters then dofile('char-def-with-ccc.lua') end
-- local characters = require "char-def-with-ccc.lua"

unicharacters.data = characters.data

return unicharacters
