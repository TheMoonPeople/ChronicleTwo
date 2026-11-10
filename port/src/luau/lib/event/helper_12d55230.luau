--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_31ae4d55 = require("@lib/event/helper_31ae4d55")
local helper_8c90fef4 = require("@lib/event/helper_8c90fef4")
local helper_b45daec0 = require("@lib/event/helper_b45daec0")
local helper_dd8a677b = require("@lib/event/helper_dd8a677b")

--- Helper function.
local function helper_12d55230(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	flag = event.get_save_flag(314) or flag
	if flag == 0 then
		helper_8c90fef4(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 17) or var3
	if var3 == 0 then
		helper_31ae4d55(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_b45daec0(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_dd8a677b(arg0, arg1)
		return
	end
end

return helper_12d55230
