--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_3023d076 = require("@lib/event/helper_3023d076")
local helper_80b5ffd8 = require("@lib/event/helper_80b5ffd8")
local helper_c2b37e16 = require("@lib/event/helper_c2b37e16")
local helper_fb164946 = require("@lib/event/helper_fb164946")

--- Helper function.
local function helper_16226690(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_fb164946(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 18) or var2
	if var2 == 0 then
		helper_3023d076(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_80b5ffd8(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_c2b37e16(arg0, arg1)
		return
	end
end

return helper_16226690
