--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_0c1bb972 = require("@lib/event/helper_0c1bb972")
local helper_63687422 = require("@lib/event/helper_63687422")
local helper_9d478496 = require("@lib/event/helper_9d478496")
local helper_d45603c6 = require("@lib/event/helper_d45603c6")

--- Helper function.
local function helper_6ffb4e4c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_d45603c6(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 15) or var2
	if var2 == 0 then
		helper_0c1bb972(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_63687422(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_9d478496(arg0, arg1)
		return
	end
end

return helper_6ffb4e4c
