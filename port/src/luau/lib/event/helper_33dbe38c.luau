--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_26b44440 = require("@lib/event/helper_26b44440")
local helper_8c90fef4 = require("@lib/event/helper_8c90fef4")
local helper_b84bf073 = require("@lib/event/helper_b84bf073")
local helper_dd8a677b = require("@lib/event/helper_dd8a677b")

--- Helper function.
local function helper_33dbe38c(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	flag = event.get_save_flag(314) or flag
	if flag == 0 then
		helper_8c90fef4(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 17) or var3
	if var3 == 0 then
		helper_b84bf073(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_26b44440(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_dd8a677b(arg0, arg1)
		return
	end
end

return helper_33dbe38c
