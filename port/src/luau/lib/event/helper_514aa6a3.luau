--!strict
-- Shared event helper used by 12 scripts, translated by tools/luau/stb2luau.

local helper_684bf7e6 = require("@lib/event/helper_684bf7e6")
local helper_6992f518 = require("@lib/event/helper_6992f518")

--- Helper function.
local function helper_514aa6a3(arg0: s32, arg1: s32)
	local argc: s32 = 0
	event.EyeViewDrawOnOff(0)
	event.SetMesEtc(1, 4, -1, -1, -1, -1)
	event.SetMesEtc(1, 9, -1, -1)
	if arg1 ~= 0 then
		helper_6992f518(1)
	else
		event.SetMesPreset(1, 3)
	end
	event.Finish()
	if arg1 == 0 then
		argc = event.GetLocalCnt(arg0) or argc
		helper_684bf7e6(arg0, argc)
	end
end

return helper_514aa6a3
