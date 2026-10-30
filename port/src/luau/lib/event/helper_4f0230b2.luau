--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_31466e4d = require("@lib/event/helper_31466e4d")
local helper_3ea1fe7a = require("@lib/event/helper_3ea1fe7a")
local helper_4c791888 = require("@lib/event/helper_4c791888")
local helper_8a71fd9c = require("@lib/event/helper_8a71fd9c")

--- Helper function.
local function helper_4f0230b2(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_3ea1fe7a(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 15) or var2
	if var2 == 0 then
		helper_4c791888(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_31466e4d(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_8a71fd9c(arg0, arg1)
		return
	end
end

return helper_4f0230b2
