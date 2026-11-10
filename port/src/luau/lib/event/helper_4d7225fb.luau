--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_306b4f96 = require("@lib/event/helper_306b4f96")
local helper_403dee95 = require("@lib/event/helper_403dee95")
local helper_58d56e28 = require("@lib/event/helper_58d56e28")
local helper_593bce69 = require("@lib/event/helper_593bce69")

--- Helper function.
local function helper_4d7225fb(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	flag = event.get_save_flag(42) or flag
	if flag == 0 then
		helper_58d56e28(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 == 0 then
		helper_306b4f96(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_403dee95(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_593bce69(arg0, arg1)
		return
	end
end

return helper_4d7225fb
