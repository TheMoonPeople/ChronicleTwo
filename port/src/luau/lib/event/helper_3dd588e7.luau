--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_c2c650e3 = require("@lib/event/helper_c2c650e3")

--- Helper function.
local function helper_3dd588e7(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_c2c650e3(arg0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, arg0)
	helper_c2c650e3(arg0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_3dd588e7
