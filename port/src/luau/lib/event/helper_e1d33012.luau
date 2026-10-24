--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_140e35ad = require("@lib/event/helper_140e35ad")
local helper_594af33d = require("@lib/event/helper_594af33d")
local helper_9f6b04d5 = require("@lib/event/helper_9f6b04d5")
local helper_e3e851e4 = require("@lib/event/helper_e3e851e4")

--- Helper function.
local function helper_e1d33012(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local flag: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	flag = event.GetFlag(424) or flag
	if var2 ~= 2 or flag == 0 then
		helper_140e35ad(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 16) or var2
	if var2 == 0 then
		helper_e3e851e4(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_9f6b04d5(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_594af33d(arg0, arg1)
		return
	end
end

return helper_e1d33012
