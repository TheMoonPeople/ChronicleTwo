--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_47171f2d = require("@lib/event/helper_47171f2d")

--- Helper function.
local function helper_c2373d02(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"The most important thing in business\nis having the trust of your customers.<page>It's something you must\nnever take for granted."
	)
	helper_47171f2d(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_c2373d02
