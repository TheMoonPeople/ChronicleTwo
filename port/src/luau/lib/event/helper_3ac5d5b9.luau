--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_4f1c9740 = require("@lib/event/helper_4f1c9740")
local helper_95948302 = require("@lib/event/helper_95948302")
local helper_b99d7c77 = require("@lib/event/helper_b99d7c77")
local helper_cca3540c = require("@lib/event/helper_cca3540c")

--- Helper function.
local function helper_3ac5d5b9(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_b99d7c77(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 15) or var2
	if var2 == 0 then
		helper_95948302(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_cca3540c(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_4f1c9740(arg0, arg1)
		return
	end
end

return helper_3ac5d5b9
