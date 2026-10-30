--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_1fc27623 = require("@lib/event/helper_1fc27623")
local helper_3c03bb6f = require("@lib/event/helper_3c03bb6f")
local helper_52b96a31 = require("@lib/event/helper_52b96a31")
local helper_c0bea0f1 = require("@lib/event/helper_c0bea0f1")

--- Helper function.
local function helper_1fc4ff92(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_3c03bb6f(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 14) or var2
	if var2 == 0 then
		helper_52b96a31(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_c0bea0f1(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_1fc27623(arg0, arg1)
		return
	end
end

return helper_1fc4ff92
