--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_1ade2465 = require("@lib/event/helper_1ade2465")
local helper_687e3195 = require("@lib/event/helper_687e3195")
local helper_af25ac00 = require("@lib/event/helper_af25ac00")
local helper_c41e8541 = require("@lib/event/helper_c41e8541")

--- Helper function.
local function helper_08215022(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_c41e8541(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 12) or var2
	if var2 == 0 then
		helper_1ade2465(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_687e3195(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_af25ac00(arg0, arg1)
		return
	end
end

return helper_08215022
