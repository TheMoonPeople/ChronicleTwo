--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_14c17c8d = require("@lib/event/helper_14c17c8d")
local helper_369cdd49 = require("@lib/event/helper_369cdd49")
local helper_94de8d8f = require("@lib/event/helper_94de8d8f")
local helper_cb478211 = require("@lib/event/helper_cb478211")

--- Helper function.
local function helper_1f6d3562(arg0: s32, arg1: s32)
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
		helper_cb478211(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_369cdd49(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_14c17c8d(arg0, arg1)
		return
	end
end

return helper_1f6d3562
