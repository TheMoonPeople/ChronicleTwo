--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_1ce0392c = require("@lib/event/helper_1ce0392c")
local helper_a89d44b7 = require("@lib/event/helper_a89d44b7")
local helper_dd2a0141 = require("@lib/event/helper_dd2a0141")
local helper_e0821a7c = require("@lib/event/helper_e0821a7c")

--- Helper function.
local function helper_62d6076f(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_dd2a0141(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 12) or var2
	if var2 == 0 then
		helper_1ce0392c(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_a89d44b7(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_e0821a7c(arg0, arg1)
		return
	end
end

return helper_62d6076f
