--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_089161b1 = require("@lib/event/helper_089161b1")
local helper_308258cd = require("@lib/event/helper_308258cd")
local helper_32003433 = require("@lib/event/helper_32003433")
local helper_c3cfdf30 = require("@lib/event/helper_c3cfdf30")

--- Helper function.
local function helper_bcbca0b7(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	flag = event.get_save_flag(42) or flag
	if flag == 0 then
		helper_308258cd(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 == 0 then
		helper_32003433(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_089161b1(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_c3cfdf30(arg0, arg1)
		return
	end
end

return helper_bcbca0b7
