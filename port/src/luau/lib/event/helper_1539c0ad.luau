--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_7308735d = require("@lib/event/helper_7308735d")
local helper_94efb068 = require("@lib/event/helper_94efb068")
local helper_e50ce8b3 = require("@lib/event/helper_e50ce8b3")
local helper_fef49d65 = require("@lib/event/helper_fef49d65")

--- Helper function.
local function helper_1539c0ad(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	flag = event.get_save_flag(314) or flag
	if flag == 0 then
		helper_94efb068(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 17) or var3
	if var3 == 0 then
		helper_e50ce8b3(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_7308735d(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_fef49d65(arg0, arg1)
		return
	end
end

return helper_1539c0ad
