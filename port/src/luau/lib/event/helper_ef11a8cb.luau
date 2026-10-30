--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_31bb850d = require("@lib/event/helper_31bb850d")
local helper_3e5e0091 = require("@lib/event/helper_3e5e0091")
local helper_96be2b9f = require("@lib/event/helper_96be2b9f")
local helper_a6614c22 = require("@lib/event/helper_a6614c22")

--- Helper function.
local function helper_ef11a8cb(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_96be2b9f(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 2) or var2
	if var2 == 0 then
		helper_3e5e0091(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_31bb850d(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_a6614c22(arg0, arg1)
		return
	end
end

return helper_ef11a8cb
