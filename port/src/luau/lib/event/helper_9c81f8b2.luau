--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_899661d6 = require("@lib/event/helper_899661d6")

--- Helper function.
local function helper_9c81f8b2(arg0: s32, arg1: any, arg2: s32)
	local var3: s32 = 0
	event.SetMesPreset(0, 0)
	var3 = event.GetChapter() or var3
	if arg2 ~= 0 and var3 == 8 then
		event.MesMake_2(0, "Je prie pour que le monde vive\nenfin en paix.")
	else
		event.MesMake_2(0, "Quand tu travailles dur pour une\nbonne cause, tu dois savoir\nr[UNI00e9]fl[UNI00e9]chir.")
	end
	helper_899661d6(arg0, -1, 0, 0)
end

return helper_9c81f8b2
