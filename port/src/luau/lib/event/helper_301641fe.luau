--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_13cd168f = require("@lib/event/helper_13cd168f")
local helper_1e2d9ad5 = require("@lib/event/helper_1e2d9ad5")
local helper_b3a2ca00 = require("@lib/event/helper_b3a2ca00")
local helper_eb490002 = require("@lib/event/helper_eb490002")

--- Helper function.
local function helper_301641fe(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_13cd168f(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 12) or var2
	if var2 == 0 then
		helper_1e2d9ad5(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_b3a2ca00(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_eb490002(arg0, arg1)
		return
	end
end

return helper_301641fe
