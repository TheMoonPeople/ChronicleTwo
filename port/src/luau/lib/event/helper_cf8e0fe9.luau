--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_08c9ebea = require("@lib/event/helper_08c9ebea")
local helper_2df5f77e = require("@lib/event/helper_2df5f77e")
local helper_33f1fc16 = require("@lib/event/helper_33f1fc16")
local helper_9e941cf3 = require("@lib/event/helper_9e941cf3")

--- Helper function.
local function helper_cf8e0fe9(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_33f1fc16(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 14) or var2
	if var2 == 0 then
		helper_2df5f77e(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_08c9ebea(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_9e941cf3(arg0, arg1)
		return
	end
end

return helper_cf8e0fe9
