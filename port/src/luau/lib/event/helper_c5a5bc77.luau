--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_6366ba72 = require("@lib/event/helper_6366ba72")
local helper_6ae5bcb2 = require("@lib/event/helper_6ae5bcb2")
local helper_8de795ad = require("@lib/event/helper_8de795ad")
local helper_b79f333a = require("@lib/event/helper_b79f333a")

--- Helper function.
local function helper_c5a5bc77(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_6366ba72(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 12) or var2
	if var2 == 0 then
		helper_b79f333a(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_6ae5bcb2(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_8de795ad(arg0, arg1)
		return
	end
end

return helper_c5a5bc77
