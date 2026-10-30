--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_1426f5e9 = require("@lib/event/helper_1426f5e9")
local helper_3c08a2d9 = require("@lib/event/helper_3c08a2d9")
local helper_60def035 = require("@lib/event/helper_60def035")
local helper_db89f583 = require("@lib/event/helper_db89f583")

--- Helper function.
local function helper_bd6bce6f(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_3c08a2d9(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 1) or var2
	if var2 == 0 then
		helper_1426f5e9(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_db89f583(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_60def035(arg0, arg1)
		return
	end
end

return helper_bd6bce6f
