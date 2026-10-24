--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_0f128988 = require("@lib/event/helper_0f128988")
local helper_1487d1fe = require("@lib/event/helper_1487d1fe")
local helper_9857fbc2 = require("@lib/event/helper_9857fbc2")
local helper_e1c25bc2 = require("@lib/event/helper_e1c25bc2")

--- Helper function.
local function helper_3e58b160(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_0f128988(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 2) or var2
	if var2 == 0 then
		helper_9857fbc2(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_e1c25bc2(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_1487d1fe(arg0, arg1)
		return
	end
end

return helper_3e58b160
