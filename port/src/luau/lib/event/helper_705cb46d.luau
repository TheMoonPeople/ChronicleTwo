--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_542b310f = require("@lib/event/helper_542b310f")
local helper_6bb0c5f5 = require("@lib/event/helper_6bb0c5f5")
local helper_9f6bb49f = require("@lib/event/helper_9f6bb49f")
local helper_aca13662 = require("@lib/event/helper_aca13662")

--- Helper function.
local function helper_705cb46d(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	flag = event.get_save_flag(42) or flag
	if flag == 0 then
		helper_aca13662(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 == 0 then
		helper_9f6bb49f(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_542b310f(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_6bb0c5f5(arg0, arg1)
		return
	end
end

return helper_705cb46d
