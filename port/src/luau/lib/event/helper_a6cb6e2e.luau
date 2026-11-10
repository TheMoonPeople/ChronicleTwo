--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_27a8ca42 = require("@lib/event/helper_27a8ca42")
local helper_aefb7549 = require("@lib/event/helper_aefb7549")
local helper_b7bf035f = require("@lib/event/helper_b7bf035f")
local helper_d4ae8452 = require("@lib/event/helper_d4ae8452")

--- Helper function.
local function helper_a6cb6e2e(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_d4ae8452(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 18) or var2
	if var2 == 0 then
		helper_27a8ca42(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_aefb7549(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_b7bf035f(arg0, arg1)
		return
	end
end

return helper_a6cb6e2e
