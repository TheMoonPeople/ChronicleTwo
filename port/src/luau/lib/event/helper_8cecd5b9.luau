--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_12cfb19e = require("@lib/event/helper_12cfb19e")
local helper_9e5281db = require("@lib/event/helper_9e5281db")
local helper_c844d61e = require("@lib/event/helper_c844d61e")
local helper_cadd9e1e = require("@lib/event/helper_cadd9e1e")

--- Helper function.
local function helper_8cecd5b9(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	flag = event.get_save_flag(314) or flag
	if flag == 0 then
		helper_cadd9e1e(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 17) or var3
	if var3 == 0 then
		helper_9e5281db(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_c844d61e(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_12cfb19e(arg0, arg1)
		return
	end
end

return helper_8cecd5b9
