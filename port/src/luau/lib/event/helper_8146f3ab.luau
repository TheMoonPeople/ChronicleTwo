--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_47171f2d = require("@lib/event/helper_47171f2d")

--- Helper function.
local function helper_8146f3ab(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_47171f2d(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Why do I miss the moon so much?<page>I wonder if that's where I\ncame from...")
	helper_47171f2d(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_8146f3ab
