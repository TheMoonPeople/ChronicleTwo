--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_33f1fc16 = require("@lib/event/helper_33f1fc16")
local helper_81acdbcc = require("@lib/event/helper_81acdbcc")
local helper_90596eab = require("@lib/event/helper_90596eab")
local helper_9e941cf3 = require("@lib/event/helper_9e941cf3")

--- Helper function.
local function helper_7c1fe17f(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_33f1fc16(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 14) or var2
	if var2 == 0 then
		helper_90596eab(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_81acdbcc(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_9e941cf3(arg0, arg1)
		return
	end
end

return helper_7c1fe17f
