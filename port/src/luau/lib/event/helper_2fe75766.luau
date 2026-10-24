--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_05e5a21e = require("@lib/event/helper_05e5a21e")
local helper_18dd708a = require("@lib/event/helper_18dd708a")
local helper_a16d7bae = require("@lib/event/helper_a16d7bae")
local helper_fc98cd99 = require("@lib/event/helper_fc98cd99")

--- Helper function.
local function helper_2fe75766(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_fc98cd99(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 19) or var2
	if var2 == 0 then
		helper_18dd708a(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_05e5a21e(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_a16d7bae(arg0, arg1)
		return
	end
end

return helper_2fe75766
