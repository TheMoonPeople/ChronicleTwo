--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_4c78170f = require("@lib/event/helper_4c78170f")
local helper_92b43a68 = require("@lib/event/helper_92b43a68")
local helper_b1a111d2 = require("@lib/event/helper_b1a111d2")
local helper_e71bcd3d = require("@lib/event/helper_e71bcd3d")

--- Helper function.
local function helper_601200b0(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_b1a111d2(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 18) or var2
	if var2 == 0 then
		helper_e71bcd3d(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_4c78170f(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_92b43a68(arg0, arg1)
		return
	end
end

return helper_601200b0
