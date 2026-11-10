--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_342a37b0 = require("@lib/event/helper_342a37b0")
local helper_b84429a4 = require("@lib/event/helper_b84429a4")
local helper_c5ea1698 = require("@lib/event/helper_c5ea1698")
local helper_e538a72d = require("@lib/event/helper_e538a72d")
local helper_ee09935e = require("@lib/event/helper_ee09935e")

--- Helper function.
local function helper_0e85caf6()
	if helper_e538a72d() ~= 0 then
		return 1
	end
	if helper_342a37b0() ~= 0 then
		return 1
	end
	if helper_ee09935e() ~= 0 then
		return 1
	end
	if helper_b84429a4() ~= 0 then
		return 1
	end
	if helper_c5ea1698() ~= 0 then
		return 1
	end
	return 0
end

return helper_0e85caf6
