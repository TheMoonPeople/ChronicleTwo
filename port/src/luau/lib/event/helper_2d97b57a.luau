--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_899661d6 = require("@lib/event/helper_899661d6")

--- Helper function.
local function helper_2d97b57a(arg0: s32, arg1: any, arg2: s32)
	local var3: s32 = 0
	event.SetMesPreset(0, 0)
	var3 = event.GetChapter() or var3
	if arg2 ~= 0 and var3 == 8 then
		event.MesMake_2(0, "I pray that the world will\nfrom today forever be at peace.")
	else
		event.MesMake_2(0, "When you're striving for a good cause,\nyou must have wisdom.")
	end
	helper_899661d6(arg0, -1, 0, 0)
end

return helper_2d97b57a
