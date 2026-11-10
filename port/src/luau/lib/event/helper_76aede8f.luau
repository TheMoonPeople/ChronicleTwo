--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_0e8f784b = require("@lib/event/helper_0e8f784b")
local helper_3e7a2ab0 = require("@lib/event/helper_3e7a2ab0")
local helper_c2b9f803 = require("@lib/event/helper_c2b9f803")
local helper_eeb297ef = require("@lib/event/helper_eeb297ef")

--- Helper function.
local function helper_76aede8f(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_3e7a2ab0(arg0, arg1, 0)
		return
	end
	var2 = event.get_quest_request_status(0, 13) or var2
	if var2 == 0 then
		helper_c2b9f803(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_0e8f784b(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_eeb297ef(arg0, arg1)
		return
	end
end

return helper_76aede8f
