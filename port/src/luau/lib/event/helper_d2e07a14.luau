--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_47171f2d = require("@lib/event/helper_47171f2d")

--- Helper function.
local function helper_d2e07a14(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Come on Max,\nlet's get going.<page>So where are\nwe off to?")
	else
		event.MesMake_2(0, "If you're ever in the mood for\nbread, you know where to find me.")
	end
	helper_47171f2d(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_d2e07a14
