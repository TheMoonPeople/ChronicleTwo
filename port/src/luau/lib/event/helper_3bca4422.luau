--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_6b8393fa = require("@lib/event/helper_6b8393fa")
local helper_b62e03fb = require("@lib/event/helper_b62e03fb")
local helper_c0b58ac1 = require("@lib/event/helper_c0b58ac1")
local helper_de4b34a4 = require("@lib/event/helper_de4b34a4")

--- Helper function.
local function helper_3bca4422(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_de4b34a4(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 12) or var2
	if var2 == 0 then
		helper_b62e03fb(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_6b8393fa(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_c0b58ac1(arg0, arg1)
		return
	end
end

return helper_3bca4422
