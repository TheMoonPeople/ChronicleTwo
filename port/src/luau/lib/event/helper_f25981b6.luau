--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_12e31f35 = require("@lib/event/helper_12e31f35")
local helper_1de0cf90 = require("@lib/event/helper_1de0cf90")
local helper_393c4d10 = require("@lib/event/helper_393c4d10")
local helper_7645ce54 = require("@lib/event/helper_7645ce54")

--- Helper function.
local function helper_f25981b6(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	flag = event.get_save_flag(42) or flag
	if flag == 0 then
		helper_393c4d10(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 == 0 then
		helper_12e31f35(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_7645ce54(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_1de0cf90(arg0, arg1)
		return
	end
end

return helper_f25981b6
