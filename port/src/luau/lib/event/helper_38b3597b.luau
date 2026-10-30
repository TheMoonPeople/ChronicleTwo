--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_51bf78a9 = require("@lib/event/helper_51bf78a9")
local helper_60691796 = require("@lib/event/helper_60691796")
local helper_a6d36e16 = require("@lib/event/helper_a6d36e16")
local helper_fe1b9147 = require("@lib/event/helper_fe1b9147")

--- Helper function.
local function helper_38b3597b(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_60691796(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 12) or var2
	if var2 == 0 then
		helper_fe1b9147(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_a6d36e16(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_51bf78a9(arg0, arg1)
		return
	end
end

return helper_38b3597b
