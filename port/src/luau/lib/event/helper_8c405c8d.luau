--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_17c6d1b0 = require("@lib/event/helper_17c6d1b0")
local helper_18310af5 = require("@lib/event/helper_18310af5")
local helper_ee2900aa = require("@lib/event/helper_ee2900aa")
local helper_f553ae31 = require("@lib/event/helper_f553ae31")

--- Helper function.
local function helper_8c405c8d(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_ee2900aa(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 14) or var2
	if var2 == 0 then
		helper_17c6d1b0(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_18310af5(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_f553ae31(arg0, arg1)
		return
	end
end

return helper_8c405c8d
