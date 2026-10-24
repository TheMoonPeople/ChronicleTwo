--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_3d2c769b = require("@lib/event/helper_3d2c769b")
local helper_472d2377 = require("@lib/event/helper_472d2377")
local helper_a3cbfdd6 = require("@lib/event/helper_a3cbfdd6")
local helper_cca55808 = require("@lib/event/helper_cca55808")

--- Helper function.
local function helper_6441a55c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_cca55808(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 15) or var2
	if var2 == 0 then
		helper_472d2377(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_a3cbfdd6(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_3d2c769b(arg0, arg1)
		return
	end
end

return helper_6441a55c
