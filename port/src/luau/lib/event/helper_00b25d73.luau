--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_2108734b = require("@lib/event/helper_2108734b")
local helper_37de77da = require("@lib/event/helper_37de77da")
local helper_e5d5a915 = require("@lib/event/helper_e5d5a915")
local helper_eb490002 = require("@lib/event/helper_eb490002")

--- Helper function.
local function helper_00b25d73(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_2108734b(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 12) or var2
	if var2 == 0 then
		helper_37de77da(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_e5d5a915(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_eb490002(arg0, arg1)
		return
	end
end

return helper_00b25d73
