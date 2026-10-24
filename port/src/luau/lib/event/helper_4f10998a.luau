--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_80c47de2 = require("@lib/event/helper_80c47de2")
local helper_a7f0f2ad = require("@lib/event/helper_a7f0f2ad")
local helper_b16bc283 = require("@lib/event/helper_b16bc283")
local helper_b4253db6 = require("@lib/event/helper_b4253db6")

--- Helper function.
local function helper_4f10998a(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_a7f0f2ad(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 14) or var2
	if var2 == 0 then
		helper_80c47de2(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_b16bc283(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_b4253db6(arg0, arg1)
		return
	end
end

return helper_4f10998a
