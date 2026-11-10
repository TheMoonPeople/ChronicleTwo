--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_056987e7 = require("@lib/event/helper_056987e7")
local helper_b1614d28 = require("@lib/event/helper_b1614d28")
local helper_e303dc1d = require("@lib/event/helper_e303dc1d")
local helper_faa74207 = require("@lib/event/helper_faa74207")

--- Helper function.
local function helper_4e2a00d9(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	flag = event.get_save_flag(314) or flag
	if flag == 0 then
		helper_056987e7(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 17) or var3
	if var3 == 0 then
		helper_b1614d28(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_faa74207(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_e303dc1d(arg0, arg1)
		return
	end
end

return helper_4e2a00d9
