--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_25b93541 = require("@lib/event/helper_25b93541")
local helper_265ae74b = require("@lib/event/helper_265ae74b")
local helper_2fbea1fe = require("@lib/event/helper_2fbea1fe")
local helper_728ea368 = require("@lib/event/helper_728ea368")

--- Helper function.
local function helper_50432636(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	flag = event.GetFlag(314) or flag
	if flag == 0 then
		helper_728ea368(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 17) or var3
	if var3 == 0 then
		helper_25b93541(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_2fbea1fe(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_265ae74b(arg0, arg1)
		return
	end
end

return helper_50432636
