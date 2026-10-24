--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_39432d2d = require("@lib/event/helper_39432d2d")
local helper_46a3db16 = require("@lib/event/helper_46a3db16")
local helper_8395480a = require("@lib/event/helper_8395480a")
local helper_a11de235 = require("@lib/event/helper_a11de235")

--- Helper function.
local function helper_2ff93f04(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	flag = event.GetFlag(314) or flag
	if flag == 0 then
		helper_46a3db16(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 17) or var3
	if var3 == 0 then
		helper_8395480a(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_39432d2d(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_a11de235(arg0, arg1)
		return
	end
end

return helper_2ff93f04
