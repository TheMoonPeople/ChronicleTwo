--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_31664384 = require("@lib/event/helper_31664384")
local helper_342a37b0 = require("@lib/event/helper_342a37b0")
local helper_691c3e0a = require("@lib/event/helper_691c3e0a")
local helper_c5ea1698 = require("@lib/event/helper_c5ea1698")
local helper_ee09935e = require("@lib/event/helper_ee09935e")

--- Helper function.
local function helper_0b7600c7()
	if helper_31664384() ~= 0 then
		return 1
	end
	if helper_342a37b0() ~= 0 then
		return 1
	end
	if helper_ee09935e() ~= 0 then
		return 1
	end
	if helper_691c3e0a() ~= 0 then
		return 1
	end
	if helper_c5ea1698() ~= 0 then
		return 1
	end
	return 0
end

return helper_0b7600c7
