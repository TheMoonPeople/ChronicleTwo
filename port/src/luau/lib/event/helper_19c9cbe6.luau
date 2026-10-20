--!strict
-- Shared event helper used by 25 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_500f057a = require("@lib/event/helper_500f057a")

--- Helper function.
local function helper_19c9cbe6(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_500f057a(arg0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, arg0)
	helper_500f057a(arg0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_19c9cbe6
