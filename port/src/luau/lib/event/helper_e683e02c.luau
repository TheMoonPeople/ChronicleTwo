--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_2f15708a = require("@lib/event/helper_2f15708a")
local helper_69b2a955 = require("@lib/event/helper_69b2a955")
local helper_e4018bf0 = require("@lib/event/helper_e4018bf0")
local helper_f8e8dae7 = require("@lib/event/helper_f8e8dae7")

--- Helper function.
local function helper_e683e02c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_69b2a955(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 1) or var2
	if var2 == 0 then
		helper_2f15708a(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_e4018bf0(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_f8e8dae7(arg0, arg1)
		return
	end
end

return helper_e683e02c
