--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_656ad2c8 = require("@lib/event/helper_656ad2c8")
local helper_846be238 = require("@lib/event/helper_846be238")
local helper_8788f143 = require("@lib/event/helper_8788f143")
local helper_d8d03c99 = require("@lib/event/helper_d8d03c99")

--- Helper function.
local function helper_aed23307(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_8788f143(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 12) or var2
	if var2 == 0 then
		helper_846be238(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_656ad2c8(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_d8d03c99(arg0, arg1)
		return
	end
end

return helper_aed23307
