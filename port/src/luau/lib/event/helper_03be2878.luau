--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_4d07a1e4 = require("@lib/event/helper_4d07a1e4")
local helper_9b113048 = require("@lib/event/helper_9b113048")
local helper_f11fa4fe = require("@lib/event/helper_f11fa4fe")
local helper_f3314905 = require("@lib/event/helper_f3314905")

--- Helper function.
local function helper_03be2878(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_f3314905(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 14) or var2
	if var2 == 0 then
		helper_4d07a1e4(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_9b113048(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_f11fa4fe(arg0, arg1)
		return
	end
end

return helper_03be2878
