--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_e574e1f1 = require("@lib/event/helper_e574e1f1")

--- Helper function.
local function helper_949157d8(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_e574e1f1(arg0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, arg0)
	helper_e574e1f1(arg0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_949157d8
