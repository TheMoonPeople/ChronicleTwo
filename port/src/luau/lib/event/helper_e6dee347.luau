--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_70253f7f = require("@lib/event/helper_70253f7f")
local helper_a5df336a = require("@lib/event/helper_a5df336a")
local helper_bb6993ce = require("@lib/event/helper_bb6993ce")
local helper_c77b4da0 = require("@lib/event/helper_c77b4da0")

--- Helper function.
local function helper_e6dee347(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local flag: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	flag = event.get_save_flag(424) or flag
	if var2 ~= 2 or flag == 0 then
		helper_c77b4da0(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 16) or var2
	if var2 == 0 then
		helper_bb6993ce(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_a5df336a(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_70253f7f(arg0, arg1)
		return
	end
end

return helper_e6dee347
