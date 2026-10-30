--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_448af381 = require("@lib/event/helper_448af381")
local helper_6a6222ef = require("@lib/event/helper_6a6222ef")
local helper_bd7d07ec = require("@lib/event/helper_bd7d07ec")
local helper_f0c54bb2 = require("@lib/event/helper_f0c54bb2")

--- Helper function.
local function helper_852403e1(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.get_quest_request_status(0, 0) or var2
	if var2 ~= 2 then
		helper_448af381(arg0, arg1)
		return
	end
	var2 = event.get_quest_request_status(0, 18) or var2
	if var2 == 0 then
		helper_6a6222ef(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_bd7d07ec(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_f0c54bb2(arg0, arg1)
		return
	end
end

return helper_852403e1
