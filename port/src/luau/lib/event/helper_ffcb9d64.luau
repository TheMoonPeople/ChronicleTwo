--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_432717ea = require("@lib/event/helper_432717ea")
local helper_85491252 = require("@lib/event/helper_85491252")
local helper_dedc7af5 = require("@lib/event/helper_dedc7af5")
local helper_e28eca86 = require("@lib/event/helper_e28eca86")

--- Helper function.
local function helper_ffcb9d64(arg0: s32, arg1: s32)
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
		helper_e28eca86(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_dedc7af5(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_432717ea(arg0, arg1)
		return
	end
end

return helper_ffcb9d64
