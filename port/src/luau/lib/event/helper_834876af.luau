--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_793144f1 = require("@lib/event/helper_793144f1")
local helper_a7f0f2ad = require("@lib/event/helper_a7f0f2ad")
local helper_b231c355 = require("@lib/event/helper_b231c355")
local helper_b4253db6 = require("@lib/event/helper_b4253db6")

--- Helper function.
local function helper_834876af(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_a7f0f2ad(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 14) or var2
	if var2 == 0 then
		helper_793144f1(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_b231c355(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_b4253db6(arg0, arg1)
		return
	end
end

return helper_834876af
