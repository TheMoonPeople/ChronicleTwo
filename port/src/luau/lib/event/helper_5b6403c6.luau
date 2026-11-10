--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_14c17c8d = require("@lib/event/helper_14c17c8d")
local helper_2eb60c95 = require("@lib/event/helper_2eb60c95")
local helper_88359ef1 = require("@lib/event/helper_88359ef1")
local helper_94de8d8f = require("@lib/event/helper_94de8d8f")

--- Helper function.
local function helper_5b6403c6(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local flag: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	flag = event.get_save_flag(424) or flag
	if var2 ~= 2 or flag == 0 then
		helper_94de8d8f(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 16) or var2
	if var2 == 0 then
		helper_88359ef1(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_2eb60c95(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_14c17c8d(arg0, arg1)
		return
	end
end

return helper_5b6403c6
