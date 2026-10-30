--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_5ee22d52 = require("@lib/event/helper_5ee22d52")
local helper_69b2a955 = require("@lib/event/helper_69b2a955")
local helper_cc2a6e00 = require("@lib/event/helper_cc2a6e00")
local helper_f8e8dae7 = require("@lib/event/helper_f8e8dae7")

--- Helper function.
local function helper_25b52de7(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_69b2a955(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 1) or var2
	if var2 == 0 then
		helper_cc2a6e00(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_5ee22d52(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_f8e8dae7(arg0, arg1)
		return
	end
end

return helper_25b52de7
