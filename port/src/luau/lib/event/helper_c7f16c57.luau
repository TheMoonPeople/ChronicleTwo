--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_2727f3d5 = require("@lib/event/helper_2727f3d5")
local helper_3019d791 = require("@lib/event/helper_3019d791")
local helper_75363875 = require("@lib/event/helper_75363875")
local helper_81433809 = require("@lib/event/helper_81433809")

--- Helper function.
local function helper_c7f16c57(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_2727f3d5(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 14) or var2
	if var2 == 0 then
		helper_75363875(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_81433809(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_3019d791(arg0, arg1)
		return
	end
end

return helper_c7f16c57
