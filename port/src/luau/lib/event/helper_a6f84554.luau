--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_2918f3cd = require("@lib/event/helper_2918f3cd")
local helper_70f342f6 = require("@lib/event/helper_70f342f6")
local helper_b0d19462 = require("@lib/event/helper_b0d19462")
local helper_dfc8eadf = require("@lib/event/helper_dfc8eadf")

--- Helper function.
local function helper_a6f84554(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_dfc8eadf(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 15) or var2
	if var2 == 0 then
		helper_b0d19462(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_70f342f6(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_2918f3cd(arg0, arg1)
		return
	end
end

return helper_a6f84554
