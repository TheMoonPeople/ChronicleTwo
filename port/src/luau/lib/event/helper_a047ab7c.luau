--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_735d0b46 = require("@lib/event/helper_735d0b46")
local helper_c4f7210b = require("@lib/event/helper_c4f7210b")
local helper_ebee3d4d = require("@lib/event/helper_ebee3d4d")
local helper_fe1a58a6 = require("@lib/event/helper_fe1a58a6")

--- Helper function.
local function helper_a047ab7c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_c4f7210b(arg0, arg1, 0)
		return
	end
	var2 = event.get_quest_request_status(0, 13) or var2
	if var2 == 0 then
		helper_ebee3d4d(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_fe1a58a6(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_735d0b46(arg0, arg1)
		return
	end
end

return helper_a047ab7c
