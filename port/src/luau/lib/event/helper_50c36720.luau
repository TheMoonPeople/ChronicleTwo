--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_2d80dc57 = require("@lib/event/helper_2d80dc57")
local helper_b891c7b6 = require("@lib/event/helper_b891c7b6")
local helper_ea1f2908 = require("@lib/event/helper_ea1f2908")
local helper_f39e9223 = require("@lib/event/helper_f39e9223")

--- Helper function.
local function helper_50c36720(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_b891c7b6(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 15) or var2
	if var2 == 0 then
		helper_ea1f2908(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_2d80dc57(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_f39e9223(arg0, arg1)
		return
	end
end

return helper_50c36720
