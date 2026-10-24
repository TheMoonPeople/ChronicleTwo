--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_14401326 = require("@lib/event/helper_14401326")
local helper_5fef7bf1 = require("@lib/event/helper_5fef7bf1")
local helper_6a29e102 = require("@lib/event/helper_6a29e102")
local helper_9f9b9b44 = require("@lib/event/helper_9f9b9b44")

--- Helper function.
local function helper_ded1ddaf(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_5fef7bf1(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 15) or var2
	if var2 == 0 then
		helper_9f9b9b44(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_14401326(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_6a29e102(arg0, arg1)
		return
	end
end

return helper_ded1ddaf
