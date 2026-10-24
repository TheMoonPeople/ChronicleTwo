--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_aa4f047e = require("@lib/event/helper_aa4f047e")
local helper_dd00ae6e = require("@lib/event/helper_dd00ae6e")
local helper_e9c7e200 = require("@lib/event/helper_e9c7e200")
local helper_fbc0d2b3 = require("@lib/event/helper_fbc0d2b3")

--- Helper function.
local function helper_17dff7d2(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	flag = event.GetFlag(314) or flag
	if flag == 0 then
		helper_fbc0d2b3(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 17) or var3
	if var3 == 0 then
		helper_e9c7e200(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_aa4f047e(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_dd00ae6e(arg0, arg1)
		return
	end
end

return helper_17dff7d2
