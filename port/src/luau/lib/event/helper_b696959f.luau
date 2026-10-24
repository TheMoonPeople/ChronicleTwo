--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_64f65f03 = require("@lib/event/helper_64f65f03")
local helper_a673baae = require("@lib/event/helper_a673baae")
local helper_c4be310b = require("@lib/event/helper_c4be310b")
local helper_dc7efd32 = require("@lib/event/helper_dc7efd32")

--- Helper function.
local function helper_b696959f(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	flag = event.GetFlag(42) or flag
	if flag == 0 then
		helper_c4be310b(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 == 0 then
		helper_a673baae(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_64f65f03(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_dc7efd32(arg0, arg1)
		return
	end
end

return helper_b696959f
