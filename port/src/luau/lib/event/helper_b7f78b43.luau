--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_3a9e310a = require("@lib/event/helper_3a9e310a")
local helper_4cd6af76 = require("@lib/event/helper_4cd6af76")
local helper_5e380014 = require("@lib/event/helper_5e380014")
local helper_744ed4fb = require("@lib/event/helper_744ed4fb")

--- Helper function.
local function helper_b7f78b43(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_5e380014(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 4) or var2
	if var2 == 0 then
		helper_3a9e310a(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_744ed4fb(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_4cd6af76(arg0, arg1)
		return
	end
end

return helper_b7f78b43
