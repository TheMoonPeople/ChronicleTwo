--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_29503c94 = require("@lib/event/helper_29503c94")
local helper_60065de4 = require("@lib/event/helper_60065de4")
local helper_edba2b47 = require("@lib/event/helper_edba2b47")
local helper_f0387ad2 = require("@lib/event/helper_f0387ad2")

--- Helper function.
local function helper_edbc1b3c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_f0387ad2(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 2) or var2
	if var2 == 0 then
		helper_60065de4(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_29503c94(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_edba2b47(arg0, arg1)
		return
	end
end

return helper_edbc1b3c
