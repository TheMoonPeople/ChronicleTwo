--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_c8368f91 = require("@lib/event/helper_c8368f91")

--- Helper function.
local function helper_a2a9cc01(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_c8368f91(arg0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, arg0)
	helper_c8368f91(arg0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_a2a9cc01
