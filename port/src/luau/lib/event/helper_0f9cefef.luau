--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_49d466e2 = require("@lib/event/helper_49d466e2")
local helper_4cd6af76 = require("@lib/event/helper_4cd6af76")
local helper_5e380014 = require("@lib/event/helper_5e380014")
local helper_66a4f497 = require("@lib/event/helper_66a4f497")

--- Helper function.
local function helper_0f9cefef(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_5e380014(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 4) or var2
	if var2 == 0 then
		helper_49d466e2(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_66a4f497(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_4cd6af76(arg0, arg1)
		return
	end
end

return helper_0f9cefef
