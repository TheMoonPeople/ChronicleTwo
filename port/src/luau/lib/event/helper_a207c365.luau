--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_4f1c9740 = require("@lib/event/helper_4f1c9740")
local helper_72e4b9be = require("@lib/event/helper_72e4b9be")
local helper_b82d9a9d = require("@lib/event/helper_b82d9a9d")
local helper_b99d7c77 = require("@lib/event/helper_b99d7c77")

--- Helper function.
local function helper_a207c365(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_b99d7c77(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 15) or var2
	if var2 == 0 then
		helper_72e4b9be(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_b82d9a9d(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_4f1c9740(arg0, arg1)
		return
	end
end

return helper_a207c365
