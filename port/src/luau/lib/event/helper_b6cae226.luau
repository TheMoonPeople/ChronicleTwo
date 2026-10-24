--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_2db4207e = require("@lib/event/helper_2db4207e")
local helper_a0f302b0 = require("@lib/event/helper_a0f302b0")
local helper_a960121a = require("@lib/event/helper_a960121a")
local helper_f68a99a3 = require("@lib/event/helper_f68a99a3")

--- Helper function.
local function helper_b6cae226()
	if helper_f68a99a3() ~= 0 then
		return 1
	end
	if helper_a960121a() ~= 0 then
		return 1
	end
	if helper_a0f302b0() ~= 0 then
		return 1
	end
	if helper_2db4207e() ~= 0 then
		return 1
	end
	return 0
end

return helper_b6cae226
