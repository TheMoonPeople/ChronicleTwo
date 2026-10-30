--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_7de24390 = require("@lib/event/helper_7de24390")
local helper_b2cbc8f0 = require("@lib/event/helper_b2cbc8f0")
local helper_b7bf035f = require("@lib/event/helper_b7bf035f")
local helper_d4ae8452 = require("@lib/event/helper_d4ae8452")

--- Helper function.
local function helper_e4ca14a4(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_d4ae8452(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 18) or var2
	if var2 == 0 then
		helper_b2cbc8f0(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_7de24390(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_b7bf035f(arg0, arg1)
		return
	end
end

return helper_e4ca14a4
