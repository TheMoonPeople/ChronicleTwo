--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_081b9dd1 = require("@lib/event/helper_081b9dd1")
local helper_8c37f115 = require("@lib/event/helper_8c37f115")
local helper_b7af5c21 = require("@lib/event/helper_b7af5c21")
local helper_d1ad6b85 = require("@lib/event/helper_d1ad6b85")

--- Helper function.
local function helper_5d48770f(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_b7af5c21(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 4) or var2
	if var2 == 0 then
		helper_8c37f115(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_d1ad6b85(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_081b9dd1(arg0, arg1)
		return
	end
end

return helper_5d48770f
