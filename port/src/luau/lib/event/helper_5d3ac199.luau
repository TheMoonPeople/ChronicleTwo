--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_15f97698 = require("@lib/event/helper_15f97698")
local helper_28d75d7c = require("@lib/event/helper_28d75d7c")
local helper_af0de7da = require("@lib/event/helper_af0de7da")
local helper_dcb0cb48 = require("@lib/event/helper_dcb0cb48")

--- Helper function.
local function helper_5d3ac199(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	flag = event.get_save_flag(42) or flag
	if flag == 0 then
		helper_15f97698(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 == 0 then
		helper_28d75d7c(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_dcb0cb48(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_af0de7da(arg0, arg1)
		return
	end
end

return helper_5d3ac199
