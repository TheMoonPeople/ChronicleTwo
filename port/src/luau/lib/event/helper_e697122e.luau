--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_81c96e3d = require("@lib/event/helper_81c96e3d")
local helper_8d1d00e2 = require("@lib/event/helper_8d1d00e2")
local helper_c73a5f1f = require("@lib/event/helper_c73a5f1f")
local helper_fba6a7db = require("@lib/event/helper_fba6a7db")

--- Helper function.
local function helper_e697122e(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_fba6a7db(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 19) or var2
	if var2 == 0 then
		helper_c73a5f1f(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_81c96e3d(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_8d1d00e2(arg0, arg1)
		return
	end
end

return helper_e697122e
