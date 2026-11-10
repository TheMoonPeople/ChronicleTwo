--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_279a6261 = require("@lib/event/helper_279a6261")
local helper_cb453bb7 = require("@lib/event/helper_cb453bb7")
local helper_f11fa4fe = require("@lib/event/helper_f11fa4fe")
local helper_f3314905 = require("@lib/event/helper_f3314905")

--- Helper function.
local function helper_07557f61(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_f3314905(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 14) or var2
	if var2 == 0 then
		helper_279a6261(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_cb453bb7(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_f11fa4fe(arg0, arg1)
		return
	end
end

return helper_07557f61
