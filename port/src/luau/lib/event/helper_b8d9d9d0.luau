--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_0de8bf9e = require("@lib/event/helper_0de8bf9e")
local helper_c2b1ab66 = require("@lib/event/helper_c2b1ab66")

--- Helper function.
local function helper_b8d9d9d0()
	local flag: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	flag = event.get_save_flag(21) or flag
	if flag == 1 then
		event.set_function_point_enabled("p01_e01g01-0", "invent_36-0", 1)
	end
	var1 = event.get_save_data_value(0) or var1
	if var1 == 2 or var1 == 3 then
		helper_c2b1ab66()
		helper_0de8bf9e(1)
	else
		event.set_function_point_enabled("", "event_550", 0)
		helper_0de8bf9e(0)
	end
	var2 = event.get_save_data_value(0) or var2
	if var2 == 100 then
		event.set_function_point_enabled("", "dun01", 0)
		event.set_function_point_enabled("", "event_550", 1)
		event.set_function_point_enabled("p01_e01g01-0", "invent_36-0", 1)
	end
end

return helper_b8d9d9d0
