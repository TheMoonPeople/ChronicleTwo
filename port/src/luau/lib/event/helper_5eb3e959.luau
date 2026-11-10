--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_5dbe958b = require("@lib/event/helper_5dbe958b")
local helper_a7691fb0 = require("@lib/event/helper_a7691fb0")
local helper_aa1161c9 = require("@lib/event/helper_aa1161c9")
local helper_c8c4c6f8 = require("@lib/event/helper_c8c4c6f8")

--- Helper function.
local function helper_5eb3e959(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_5dbe958b(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 2) or var2
	if var2 == 0 then
		helper_aa1161c9(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_a7691fb0(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_c8c4c6f8(arg0, arg1)
		return
	end
end

return helper_5eb3e959
