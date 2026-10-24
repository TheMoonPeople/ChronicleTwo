--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_2c20ac62 = require("@lib/event/helper_2c20ac62")
local helper_2f61e008 = require("@lib/event/helper_2f61e008")
local helper_83826176 = require("@lib/event/helper_83826176")
local helper_e95b676b = require("@lib/event/helper_e95b676b")

--- Helper function.
local function helper_0f18cddd(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_2f61e008(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 4) or var2
	if var2 == 0 then
		helper_e95b676b(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_83826176(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_2c20ac62(arg0, arg1)
		return
	end
end

return helper_0f18cddd
