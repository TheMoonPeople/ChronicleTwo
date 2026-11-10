--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_26293a44 = require("@lib/event/helper_26293a44")
local helper_54f42506 = require("@lib/event/helper_54f42506")
local helper_628ef5bd = require("@lib/event/helper_628ef5bd")
local helper_6ca976aa = require("@lib/event/helper_6ca976aa")

--- Helper function.
local function helper_17325562(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_26293a44(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 12) or var2
	if var2 == 0 then
		helper_628ef5bd(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_6ca976aa(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_54f42506(arg0, arg1)
		return
	end
end

return helper_17325562
