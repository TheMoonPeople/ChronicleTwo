--!strict
-- Shared event helper used by 35 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_53a7bb37 = require("@lib/event/helper_53a7bb37")

--- Helper function.
local function helper_c3ce9c48(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_53a7bb37(arg0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, arg0)
	helper_53a7bb37(arg0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_c3ce9c48
