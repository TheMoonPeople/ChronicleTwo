--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_1cdf1bb4 = require("@lib/event/helper_1cdf1bb4")
local helper_ab39c9ae = require("@lib/event/helper_ab39c9ae")
local helper_c19a850f = require("@lib/event/helper_c19a850f")
local helper_f9c5ff4b = require("@lib/event/helper_f9c5ff4b")

--- Helper function.
local function helper_f6fb599a(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_ab39c9ae(arg0, arg1, 0)
		return
	end
	var2 = event.get_quest_request_status(0, 13) or var2
	if var2 == 0 then
		helper_c19a850f(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_f9c5ff4b(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_1cdf1bb4(arg0, arg1)
		return
	end
end

return helper_f6fb599a
