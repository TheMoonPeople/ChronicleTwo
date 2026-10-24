--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_09ce03a0 = require("@lib/event/helper_09ce03a0")
local helper_10611008 = require("@lib/event/helper_10611008")
local helper_145d92f0 = require("@lib/event/helper_145d92f0")
local helper_e28b3446 = require("@lib/event/helper_e28b3446")

--- Helper function.
local function helper_01e77860(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_e28b3446(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 1) or var2
	if var2 == 0 then
		helper_10611008(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_09ce03a0(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_145d92f0(arg0, arg1)
		return
	end
end

return helper_01e77860
