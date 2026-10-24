--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_4f04ffab = require("@lib/event/helper_4f04ffab")
local helper_94984651 = require("@lib/event/helper_94984651")
local helper_c13b76f2 = require("@lib/event/helper_c13b76f2")
local helper_f8f57384 = require("@lib/event/helper_f8f57384")

--- Helper function.
local function helper_772c16ce(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_94984651(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 18) or var2
	if var2 == 0 then
		helper_4f04ffab(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_f8f57384(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_c13b76f2(arg0, arg1)
		return
	end
end

return helper_772c16ce
