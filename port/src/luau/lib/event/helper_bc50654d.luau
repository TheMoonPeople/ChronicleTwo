--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_2d97b57a = require("@lib/event/helper_2d97b57a")
local helper_4c935128 = require("@lib/event/helper_4c935128")
local helper_a93aafc9 = require("@lib/event/helper_a93aafc9")
local helper_e370e29c = require("@lib/event/helper_e370e29c")

--- Helper function.
local function helper_bc50654d(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_2d97b57a(arg0, arg1, 0)
		return
	end
	var2 = event.GetQuestEtc(0, 13) or var2
	if var2 == 0 then
		helper_e370e29c(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_a93aafc9(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_4c935128(arg0, arg1)
		return
	end
end

return helper_bc50654d
