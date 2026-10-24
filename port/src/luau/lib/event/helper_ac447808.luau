--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_50638d8d = require("@lib/event/helper_50638d8d")
local helper_5a890106 = require("@lib/event/helper_5a890106")
local helper_c6718a83 = require("@lib/event/helper_c6718a83")
local helper_cdcc5878 = require("@lib/event/helper_cdcc5878")

--- Helper function.
local function helper_ac447808(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_c6718a83(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 12) or var2
	if var2 == 0 then
		helper_cdcc5878(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_50638d8d(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_5a890106(arg0, arg1)
		return
	end
end

return helper_ac447808
