--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_2626ccdd = require("@lib/event/helper_2626ccdd")
local helper_2e24b503 = require("@lib/event/helper_2e24b503")
local helper_d8a4ecfd = require("@lib/event/helper_d8a4ecfd")
local helper_e20aec31 = require("@lib/event/helper_e20aec31")

--- Helper function.
local function helper_127e8072(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_2626ccdd(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 18) or var2
	if var2 == 0 then
		helper_d8a4ecfd(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_e20aec31(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_2e24b503(arg0, arg1)
		return
	end
end

return helper_127e8072
