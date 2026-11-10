--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_0d2c1f71 = require("@lib/event/helper_0d2c1f71")
local helper_51bf78a9 = require("@lib/event/helper_51bf78a9")
local helper_54c9b76a = require("@lib/event/helper_54c9b76a")
local helper_fcace249 = require("@lib/event/helper_fcace249")

--- Helper function.
local function helper_5a097408(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_54c9b76a(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 12) or var2
	if var2 == 0 then
		helper_0d2c1f71(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_fcace249(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_51bf78a9(arg0, arg1)
		return
	end
end

return helper_5a097408
