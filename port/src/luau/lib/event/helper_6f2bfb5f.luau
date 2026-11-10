--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_6bb0c5f5 = require("@lib/event/helper_6bb0c5f5")
local helper_863f4c9c = require("@lib/event/helper_863f4c9c")
local helper_aca13662 = require("@lib/event/helper_aca13662")
local helper_e5c8e90d = require("@lib/event/helper_e5c8e90d")

--- Helper function.
local function helper_6f2bfb5f(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	flag = event.get_save_flag(42) or flag
	if flag == 0 then
		helper_aca13662(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 == 0 then
		helper_e5c8e90d(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_863f4c9c(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_6bb0c5f5(arg0, arg1)
		return
	end
end

return helper_6f2bfb5f
