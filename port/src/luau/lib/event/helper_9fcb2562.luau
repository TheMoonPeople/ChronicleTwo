--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_46732ca6 = require("@lib/event/helper_46732ca6")
local helper_67654247 = require("@lib/event/helper_67654247")
local helper_94efb068 = require("@lib/event/helper_94efb068")
local helper_fef49d65 = require("@lib/event/helper_fef49d65")

--- Helper function.
local function helper_9fcb2562(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	flag = event.get_save_flag(314) or flag
	if flag == 0 then
		helper_94efb068(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 17) or var3
	if var3 == 0 then
		helper_67654247(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_46732ca6(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_fef49d65(arg0, arg1)
		return
	end
end

return helper_9fcb2562
