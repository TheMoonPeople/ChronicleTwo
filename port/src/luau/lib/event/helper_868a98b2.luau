--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_18fe774e = require("@lib/event/helper_18fe774e")
local helper_2d8b051f = require("@lib/event/helper_2d8b051f")
local helper_9d1f36b5 = require("@lib/event/helper_9d1f36b5")
local helper_db4d9a74 = require("@lib/event/helper_db4d9a74")

--- Helper function.
local function helper_868a98b2(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	flag = event.GetFlag(314) or flag
	if flag == 0 then
		helper_2d8b051f(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 17) or var3
	if var3 == 0 then
		helper_db4d9a74(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_9d1f36b5(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_18fe774e(arg0, arg1)
		return
	end
end

return helper_868a98b2
