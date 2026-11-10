--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_0fa62586 = require("@lib/event/helper_0fa62586")
local helper_bad9e90b = require("@lib/event/helper_bad9e90b")
local helper_e7d5480f = require("@lib/event/helper_e7d5480f")
local helper_f3463d90 = require("@lib/event/helper_f3463d90")

--- Helper function.
local function helper_e8e4afff(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_e7d5480f(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 12) or var2
	if var2 == 0 then
		helper_0fa62586(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_f3463d90(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_bad9e90b(arg0, arg1)
		return
	end
end

return helper_e8e4afff
