--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_2b11117f = require("@lib/event/helper_2b11117f")
local helper_491ee3a4 = require("@lib/event/helper_491ee3a4")
local helper_8253ec02 = require("@lib/event/helper_8253ec02")
local helper_f63da56d = require("@lib/event/helper_f63da56d")

--- Helper function.
local function helper_eec107f7(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_491ee3a4(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 19) or var2
	if var2 == 0 then
		helper_8253ec02(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_f63da56d(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_2b11117f(arg0, arg1)
		return
	end
end

return helper_eec107f7
