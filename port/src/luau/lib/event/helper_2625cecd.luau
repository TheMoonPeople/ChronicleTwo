--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_5fef7bf1 = require("@lib/event/helper_5fef7bf1")
local helper_6a29e102 = require("@lib/event/helper_6a29e102")
local helper_92440fc2 = require("@lib/event/helper_92440fc2")
local helper_bcf1d582 = require("@lib/event/helper_bcf1d582")

--- Helper function.
local function helper_2625cecd(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_5fef7bf1(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 15) or var2
	if var2 == 0 then
		helper_92440fc2(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_bcf1d582(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_6a29e102(arg0, arg1)
		return
	end
end

return helper_2625cecd
