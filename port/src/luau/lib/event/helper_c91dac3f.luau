--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_2016913f = require("@lib/event/helper_2016913f")
local helper_21912dd8 = require("@lib/event/helper_21912dd8")
local helper_ce3ec26c = require("@lib/event/helper_ce3ec26c")
local helper_fb9c63aa = require("@lib/event/helper_fb9c63aa")

--- Helper function.
local function helper_c91dac3f(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	flag = event.get_save_flag(314) or flag
	if flag == 0 then
		helper_21912dd8(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 17) or var3
	if var3 == 0 then
		helper_fb9c63aa(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_2016913f(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_ce3ec26c(arg0, arg1)
		return
	end
end

return helper_c91dac3f
