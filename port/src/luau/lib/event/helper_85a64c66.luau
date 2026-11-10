--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_0e4c3c21 = require("@lib/event/helper_0e4c3c21")
local helper_3c08a2d9 = require("@lib/event/helper_3c08a2d9")
local helper_60def035 = require("@lib/event/helper_60def035")
local helper_6f419256 = require("@lib/event/helper_6f419256")

--- Helper function.
local function helper_85a64c66(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_3c08a2d9(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 1) or var2
	if var2 == 0 then
		helper_0e4c3c21(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_6f419256(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_60def035(arg0, arg1)
		return
	end
end

return helper_85a64c66
