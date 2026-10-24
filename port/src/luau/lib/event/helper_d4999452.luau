--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_2955fa44 = require("@lib/event/helper_2955fa44")
local helper_68c48ba1 = require("@lib/event/helper_68c48ba1")
local helper_8b8ffc3d = require("@lib/event/helper_8b8ffc3d")
local helper_e0073e9f = require("@lib/event/helper_e0073e9f")

--- Helper function.
local function helper_d4999452(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_68c48ba1(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 14) or var2
	if var2 == 0 then
		helper_2955fa44(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_e0073e9f(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_8b8ffc3d(arg0, arg1)
		return
	end
end

return helper_d4999452
