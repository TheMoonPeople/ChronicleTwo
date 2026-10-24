--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_0a592796 = require("@lib/event/helper_0a592796")
local helper_7c7ac141 = require("@lib/event/helper_7c7ac141")
local helper_d4d3f44f = require("@lib/event/helper_d4d3f44f")
local helper_eb41ef82 = require("@lib/event/helper_eb41ef82")

--- Helper function.
local function helper_e6a92440(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_d4d3f44f(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 18) or var2
	if var2 == 0 then
		helper_0a592796(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_7c7ac141(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_eb41ef82(arg0, arg1)
		return
	end
end

return helper_e6a92440
