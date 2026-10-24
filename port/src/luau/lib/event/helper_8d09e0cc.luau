--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_2d97b57a = require("@lib/event/helper_2d97b57a")
local helper_4c935128 = require("@lib/event/helper_4c935128")
local helper_697b7fe4 = require("@lib/event/helper_697b7fe4")
local helper_8749a037 = require("@lib/event/helper_8749a037")

--- Helper function.
local function helper_8d09e0cc(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_2d97b57a(arg0, arg1, 0)
		return
	end
	var2 = event.GetQuestEtc(0, 13) or var2
	if var2 == 0 then
		helper_697b7fe4(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_8749a037(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_4c935128(arg0, arg1)
		return
	end
end

return helper_8d09e0cc
