--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local helper_308258cd = require("@lib/event/helper_308258cd")
local helper_47b173a6 = require("@lib/event/helper_47b173a6")
local helper_9870950a = require("@lib/event/helper_9870950a")
local helper_c3cfdf30 = require("@lib/event/helper_c3cfdf30")

--- Helper function.
local function helper_148c4e7b(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	flag = event.get_save_flag(42) or flag
	if flag == 0 then
		helper_308258cd(arg0, arg1)
		return
	end
	var3 = event.get_quest_request_status(0, 0) or var3
	if var3 == 0 then
		helper_9870950a(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_47b173a6(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_c3cfdf30(arg0, arg1)
		return
	end
end

return helper_148c4e7b
