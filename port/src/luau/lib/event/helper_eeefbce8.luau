--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_abe765d2 = require("@lib/event/helper_abe765d2")
local helper_b141ad4a = require("@lib/event/helper_b141ad4a")
local helper_c42546bc = require("@lib/event/helper_c42546bc")
local helper_db5361b5 = require("@lib/event/helper_db5361b5")

--- Helper function.
local function helper_eeefbce8(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local flag: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	flag = event.GetFlag(424) or flag
	if var2 ~= 2 or flag == 0 then
		helper_c42546bc(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 16) or var2
	if var2 == 0 then
		helper_b141ad4a(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_abe765d2(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_db5361b5(arg0, arg1)
		return
	end
end

return helper_eeefbce8
