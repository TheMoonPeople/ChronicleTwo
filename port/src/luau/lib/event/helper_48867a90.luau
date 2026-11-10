--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_1c2d4f18 = require("@lib/event/helper_1c2d4f18")
local helper_c19d7089 = require("@lib/event/helper_c19d7089")
local helper_c248f8d5 = require("@lib/event/helper_c248f8d5")
local helper_e3b9f15c = require("@lib/event/helper_e3b9f15c")

--- Helper function.
local function helper_48867a90(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_c248f8d5(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 4) or var2
	if var2 == 0 then
		helper_e3b9f15c(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_1c2d4f18(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_c19d7089(arg0, arg1)
		return
	end
end

return helper_48867a90
