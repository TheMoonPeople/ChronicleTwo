--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_2c6610c7 = require("@lib/event/helper_2c6610c7")
local helper_7d0998a2 = require("@lib/event/helper_7d0998a2")
local helper_d3953a20 = require("@lib/event/helper_d3953a20")
local helper_fa64cd57 = require("@lib/event/helper_fa64cd57")

--- Helper function.
local function helper_ccf6981a(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_fa64cd57(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 15) or var2
	if var2 == 0 then
		helper_2c6610c7(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_7d0998a2(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_d3953a20(arg0, arg1)
		return
	end
end

return helper_ccf6981a
