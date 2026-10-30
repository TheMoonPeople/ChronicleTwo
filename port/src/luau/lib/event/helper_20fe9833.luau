--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_3904fcf9 = require("@lib/event/helper_3904fcf9")
local helper_6a8c5af3 = require("@lib/event/helper_6a8c5af3")
local helper_90b678d2 = require("@lib/event/helper_90b678d2")
local helper_eb104a17 = require("@lib/event/helper_eb104a17")

--- Helper function.
local function helper_20fe9833(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_6a8c5af3(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 12) or var2
	if var2 == 0 then
		helper_3904fcf9(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_eb104a17(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_90b678d2(arg0, arg1)
		return
	end
end

return helper_20fe9833
