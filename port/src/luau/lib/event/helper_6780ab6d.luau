--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_12cfb19e = require("@lib/event/helper_12cfb19e")
local helper_4c4d40e1 = require("@lib/event/helper_4c4d40e1")
local helper_59ec5939 = require("@lib/event/helper_59ec5939")
local helper_cadd9e1e = require("@lib/event/helper_cadd9e1e")

--- Helper function.
local function helper_6780ab6d(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	flag = event.get_save_flag(314) or flag
	if flag == 0 then
		helper_cadd9e1e(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 17) or var3
	if var3 == 0 then
		helper_4c4d40e1(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_59ec5939(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_12cfb19e(arg0, arg1)
		return
	end
end

return helper_6780ab6d
