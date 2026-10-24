--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_18fe774e = require("@lib/event/helper_18fe774e")
local helper_2d8b051f = require("@lib/event/helper_2d8b051f")
local helper_7b7deb7c = require("@lib/event/helper_7b7deb7c")
local helper_c657756e = require("@lib/event/helper_c657756e")

--- Helper function.
local function helper_c9a0ac81(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	flag = event.GetFlag(314) or flag
	if flag == 0 then
		helper_2d8b051f(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 17) or var3
	if var3 == 0 then
		helper_c657756e(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_7b7deb7c(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_18fe774e(arg0, arg1)
		return
	end
end

return helper_c9a0ac81
