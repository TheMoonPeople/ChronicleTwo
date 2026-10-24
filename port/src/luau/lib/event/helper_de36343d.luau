--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_15bc0e0a = require("@lib/event/helper_15bc0e0a")
local helper_2f2c0740 = require("@lib/event/helper_2f2c0740")
local helper_8e35ac83 = require("@lib/event/helper_8e35ac83")
local helper_9c81f8b2 = require("@lib/event/helper_9c81f8b2")

--- Helper function.
local function helper_de36343d(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_9c81f8b2(arg0, arg1, 0)
		return
	end
	var2 = event.GetQuestEtc(0, 13) or var2
	if var2 == 0 then
		helper_8e35ac83(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_2f2c0740(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_15bc0e0a(arg0, arg1)
		return
	end
end

return helper_de36343d
