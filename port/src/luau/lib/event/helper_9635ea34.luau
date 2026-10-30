--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_248c2cfc = require("@lib/event/helper_248c2cfc")
local helper_58d56e28 = require("@lib/event/helper_58d56e28")
local helper_593bce69 = require("@lib/event/helper_593bce69")
local helper_612c6ef4 = require("@lib/event/helper_612c6ef4")

--- Helper function.
local function helper_9635ea34(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	flag = event.get_save_flag(42) or flag
	if flag == 0 then
		helper_58d56e28(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 == 0 then
		helper_612c6ef4(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_248c2cfc(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_593bce69(arg0, arg1)
		return
	end
end

return helper_9635ea34
