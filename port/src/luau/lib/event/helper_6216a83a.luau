--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_5cc5a0d6 = require("@lib/event/helper_5cc5a0d6")
local helper_8494cef1 = require("@lib/event/helper_8494cef1")
local helper_9013f56d = require("@lib/event/helper_9013f56d")
local helper_fdc473af = require("@lib/event/helper_fdc473af")

--- Helper function.
local function helper_6216a83a(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	flag = event.GetFlag(42) or flag
	if flag == 0 then
		helper_fdc473af(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 == 0 then
		helper_5cc5a0d6(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_8494cef1(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_9013f56d(arg0, arg1)
		return
	end
end

return helper_6216a83a
