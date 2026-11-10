--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_06e78016 = require("@lib/event/helper_06e78016")
local helper_21912dd8 = require("@lib/event/helper_21912dd8")
local helper_cb6dec7b = require("@lib/event/helper_cb6dec7b")
local helper_ce3ec26c = require("@lib/event/helper_ce3ec26c")

--- Helper function.
local function helper_1822fa5d(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	flag = event.get_save_flag(314) or flag
	if flag == 0 then
		helper_21912dd8(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 17) or var3
	if var3 == 0 then
		helper_cb6dec7b(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_06e78016(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_ce3ec26c(arg0, arg1)
		return
	end
end

return helper_1822fa5d
