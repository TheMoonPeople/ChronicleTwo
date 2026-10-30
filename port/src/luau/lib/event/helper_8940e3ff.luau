--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_2e13a180 = require("@lib/event/helper_2e13a180")
local helper_37275437 = require("@lib/event/helper_37275437")
local helper_3cc51291 = require("@lib/event/helper_3cc51291")
local helper_bbfc85f8 = require("@lib/event/helper_bbfc85f8")

--- Helper function.
local function helper_8940e3ff(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local flag: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	flag = event.get_save_flag(424) or flag
	if var2 ~= 2 or flag == 0 then
		helper_3cc51291(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 16) or var2
	if var2 == 0 then
		helper_2e13a180(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_bbfc85f8(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_37275437(arg0, arg1)
		return
	end
end

return helper_8940e3ff
