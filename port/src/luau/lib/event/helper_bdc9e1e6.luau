--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_2b372cd3 = require("@lib/event/helper_2b372cd3")
local helper_33e383c4 = require("@lib/event/helper_33e383c4")
local helper_3a06ffd5 = require("@lib/event/helper_3a06ffd5")
local helper_73ee7520 = require("@lib/event/helper_73ee7520")

--- Helper function.
local function helper_bdc9e1e6(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_33e383c4(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 18) or var2
	if var2 == 0 then
		helper_73ee7520(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_3a06ffd5(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_2b372cd3(arg0, arg1)
		return
	end
end

return helper_bdc9e1e6
