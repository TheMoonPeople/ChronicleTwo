--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_2ca933eb = require("@lib/event/helper_2ca933eb")
local helper_68c48ba1 = require("@lib/event/helper_68c48ba1")
local helper_8b8ffc3d = require("@lib/event/helper_8b8ffc3d")
local helper_b6c3f535 = require("@lib/event/helper_b6c3f535")

--- Helper function.
local function helper_c98fe971(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_68c48ba1(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 14) or var2
	if var2 == 0 then
		helper_b6c3f535(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_2ca933eb(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_8b8ffc3d(arg0, arg1)
		return
	end
end

return helper_c98fe971
