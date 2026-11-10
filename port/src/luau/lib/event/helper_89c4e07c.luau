--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_08c337b8 = require("@lib/event/helper_08c337b8")
local helper_72334e82 = require("@lib/event/helper_72334e82")
local helper_72cb617b = require("@lib/event/helper_72cb617b")
local helper_91c6c650 = require("@lib/event/helper_91c6c650")

--- Helper function.
local function helper_89c4e07c()
	if helper_72334e82() ~= 0 then
		return 1
	end
	if helper_72cb617b() ~= 0 then
		return 1
	end
	if helper_91c6c650() ~= 0 then
		return 1
	end
	if helper_08c337b8() ~= 0 then
		return 1
	end
	return 0
end

return helper_89c4e07c
