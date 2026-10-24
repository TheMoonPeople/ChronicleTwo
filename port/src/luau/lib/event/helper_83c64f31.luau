--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_138c0b3e = require("@lib/event/helper_138c0b3e")
local helper_c8d64c29 = require("@lib/event/helper_c8d64c29")
local helper_d9ce7910 = require("@lib/event/helper_d9ce7910")
local helper_e82009b1 = require("@lib/event/helper_e82009b1")

--- Helper function.
local function helper_83c64f31(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_e82009b1(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 19) or var2
	if var2 == 0 then
		helper_c8d64c29(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_d9ce7910(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_138c0b3e(arg0, arg1)
		return
	end
end

return helper_83c64f31
