--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_2bc580c2 = require("@lib/event/helper_2bc580c2")
local helper_aa731fbc = require("@lib/event/helper_aa731fbc")
local helper_b884e2de = require("@lib/event/helper_b884e2de")
local helper_efde1e95 = require("@lib/event/helper_efde1e95")

--- Helper function.
local function helper_978fc274(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_efde1e95(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 19) or var2
	if var2 == 0 then
		helper_b884e2de(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_2bc580c2(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_aa731fbc(arg0, arg1)
		return
	end
end

return helper_978fc274
