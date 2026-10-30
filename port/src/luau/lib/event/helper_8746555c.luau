--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_432717ea = require("@lib/event/helper_432717ea")
local helper_61744c1a = require("@lib/event/helper_61744c1a")
local helper_85491252 = require("@lib/event/helper_85491252")
local helper_d14525e2 = require("@lib/event/helper_d14525e2")

--- Helper function.
local function helper_8746555c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local flag: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	flag = event.get_save_flag(424) or flag
	if var2 ~= 2 or flag == 0 then
		helper_85491252(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 16) or var2
	if var2 == 0 then
		helper_d14525e2(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_61744c1a(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_432717ea(arg0, arg1)
		return
	end
end

return helper_8746555c
