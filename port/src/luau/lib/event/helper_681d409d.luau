--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_5040c4f0 = require("@lib/event/helper_5040c4f0")
local helper_aa731fbc = require("@lib/event/helper_aa731fbc")
local helper_b1f92055 = require("@lib/event/helper_b1f92055")
local helper_efde1e95 = require("@lib/event/helper_efde1e95")

--- Helper function.
local function helper_681d409d(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_efde1e95(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 19) or var2
	if var2 == 0 then
		helper_5040c4f0(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_b1f92055(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_aa731fbc(arg0, arg1)
		return
	end
end

return helper_681d409d
