--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_05978d55 = require("@lib/event/helper_05978d55")
local helper_70253f7f = require("@lib/event/helper_70253f7f")
local helper_c77b4da0 = require("@lib/event/helper_c77b4da0")
local helper_fdadf923 = require("@lib/event/helper_fdadf923")

--- Helper function.
local function helper_99c023b7(arg0: s32, arg1: s32)
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
		helper_fdadf923(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_05978d55(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_70253f7f(arg0, arg1)
		return
	end
end

return helper_99c023b7
