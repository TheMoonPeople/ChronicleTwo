--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_0d25d2b7 = require("@lib/event/helper_0d25d2b7")
local helper_2a26ecc0 = require("@lib/event/helper_2a26ecc0")
local helper_3bb5ecb5 = require("@lib/event/helper_3bb5ecb5")
local helper_9eb59ab5 = require("@lib/event/helper_9eb59ab5")

--- Helper function.
local function helper_aae85aa8(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_9eb59ab5(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 4) or var2
	if var2 == 0 then
		helper_0d25d2b7(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_3bb5ecb5(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_2a26ecc0(arg0, arg1)
		return
	end
end

return helper_aae85aa8
