--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_1de0cf90 = require("@lib/event/helper_1de0cf90")
local helper_393c4d10 = require("@lib/event/helper_393c4d10")
local helper_758029ec = require("@lib/event/helper_758029ec")
local helper_daddea4e = require("@lib/event/helper_daddea4e")

--- Helper function.
local function helper_f5c274e4(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	flag = event.get_save_flag(42) or flag
	if flag == 0 then
		helper_393c4d10(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 == 0 then
		helper_daddea4e(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_758029ec(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_1de0cf90(arg0, arg1)
		return
	end
end

return helper_f5c274e4
