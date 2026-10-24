--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_3109b729 = require("@lib/event/helper_3109b729")
local helper_3e28d4e7 = require("@lib/event/helper_3e28d4e7")
local helper_4b0d9b02 = require("@lib/event/helper_4b0d9b02")
local helper_f819ef75 = require("@lib/event/helper_f819ef75")

--- Helper function.
local function helper_d34d53c4(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local flag: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	flag = event.GetFlag(424) or flag
	if var2 ~= 2 or flag == 0 then
		helper_4b0d9b02(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 16) or var2
	if var2 == 0 then
		helper_3e28d4e7(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_3109b729(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_f819ef75(arg0, arg1)
		return
	end
end

return helper_d34d53c4
