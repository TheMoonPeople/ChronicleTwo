--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_b408a067 = require("@lib/event/helper_b408a067")

--- Helper function.
local function helper_8e9e4151(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b408a067(arg0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, arg0)
	helper_b408a067(arg0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_8e9e4151
