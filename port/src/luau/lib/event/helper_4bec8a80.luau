--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_0f7973a0 = require("@lib/event/helper_0f7973a0")
local helper_611ae120 = require("@lib/event/helper_611ae120")
local helper_98e7f7b8 = require("@lib/event/helper_98e7f7b8")
local helper_b8c86642 = require("@lib/event/helper_b8c86642")

--- Helper function.
local function helper_4bec8a80(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_98e7f7b8(arg0, arg1, 0)
		return
	end
	var2 = event.get_quest_request_status(0, 13) or var2
	if var2 == 0 then
		helper_0f7973a0(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_b8c86642(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_611ae120(arg0, arg1)
		return
	end
end

return helper_4bec8a80
