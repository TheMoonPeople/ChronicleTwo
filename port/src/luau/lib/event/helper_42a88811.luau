--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_00e1e86d = require("@lib/event/helper_00e1e86d")
local helper_140e35ad = require("@lib/event/helper_140e35ad")
local helper_594af33d = require("@lib/event/helper_594af33d")
local helper_86a1a67d = require("@lib/event/helper_86a1a67d")

--- Helper function.
local function helper_42a88811(arg0: s32, arg1: s32)
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
		helper_86a1a67d(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_00e1e86d(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_594af33d(arg0, arg1)
		return
	end
end

return helper_42a88811
