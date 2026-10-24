--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_504be7bf = require("@lib/event/helper_504be7bf")
local helper_5885067c = require("@lib/event/helper_5885067c")
local helper_a5bddd4a = require("@lib/event/helper_a5bddd4a")
local helper_b9135d8a = require("@lib/event/helper_b9135d8a")

--- Helper function.
local function helper_beae94b8(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_5885067c(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 18) or var2
	if var2 == 0 then
		helper_504be7bf(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_a5bddd4a(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_b9135d8a(arg0, arg1)
		return
	end
end

return helper_beae94b8
