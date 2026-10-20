--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4f3e3110 = require("@lib/event/helper_4f3e3110")

--- Helper function.
local function helper_a65ad647(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_4f3e3110(arg0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, arg0)
	helper_4f3e3110(arg0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_a65ad647
