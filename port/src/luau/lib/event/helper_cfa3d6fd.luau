--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_1c4d6b12 = require("@lib/event/helper_1c4d6b12")
local helper_42d8cb0e = require("@lib/event/helper_42d8cb0e")
local helper_5564f154 = require("@lib/event/helper_5564f154")
local helper_e369b7e4 = require("@lib/event/helper_e369b7e4")

--- Helper function.
local function helper_cfa3d6fd(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local flag: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	flag = event.GetFlag(424) or flag
	if var2 ~= 2 or flag == 0 then
		helper_5564f154(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 16) or var2
	if var2 == 0 then
		helper_e369b7e4(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_1c4d6b12(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_42d8cb0e(arg0, arg1)
		return
	end
end

return helper_cfa3d6fd
