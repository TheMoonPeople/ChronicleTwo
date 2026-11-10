--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_3e7a2ab0 = require("@lib/event/helper_3e7a2ab0")
local helper_60cf1b32 = require("@lib/event/helper_60cf1b32")
local helper_e67cd8b5 = require("@lib/event/helper_e67cd8b5")
local helper_eeb297ef = require("@lib/event/helper_eeb297ef")

--- Helper function.
local function helper_4becd931(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_3e7a2ab0(arg0, arg1, 0)
		return
	end
	var2 = event.get_quest_request_status(0, 13) or var2
	if var2 == 0 then
		helper_e67cd8b5(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_60cf1b32(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_eeb297ef(arg0, arg1)
		return
	end
end

return helper_4becd931
