--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_4278d89d = require("@lib/event/helper_4278d89d")
local helper_63aeb880 = require("@lib/event/helper_63aeb880")
local helper_a9bb14c3 = require("@lib/event/helper_a9bb14c3")
local helper_f41efaa8 = require("@lib/event/helper_f41efaa8")

--- Helper function.
local function helper_40f3e1d7(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_4278d89d(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 19) or var2
	if var2 == 0 then
		helper_63aeb880(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_f41efaa8(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_a9bb14c3(arg0, arg1)
		return
	end
end

return helper_40f3e1d7
