--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_01981c92 = require("@lib/event/helper_01981c92")
local helper_85ae3b68 = require("@lib/event/helper_85ae3b68")
local helper_97fb27d6 = require("@lib/event/helper_97fb27d6")
local helper_cf11ee73 = require("@lib/event/helper_cf11ee73")

--- Helper function.
local function helper_8d20339a(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local flag: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	flag = event.get_save_flag(424) or flag
	if var2 ~= 2 or flag == 0 then
		helper_85ae3b68(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 16) or var2
	if var2 == 0 then
		helper_97fb27d6(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_cf11ee73(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_01981c92(arg0, arg1)
		return
	end
end

return helper_8d20339a
