--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_3d860c38 = require("@lib/event/helper_3d860c38")
local helper_3f832710 = require("@lib/event/helper_3f832710")
local helper_82d93124 = require("@lib/event/helper_82d93124")
local helper_ffc6ae46 = require("@lib/event/helper_ffc6ae46")

--- Helper function.
local function helper_d9dc0658(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	flag = event.GetFlag(42) or flag
	if flag == 0 then
		helper_3f832710(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 == 0 then
		helper_ffc6ae46(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_82d93124(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_3d860c38(arg0, arg1)
		return
	end
end

return helper_d9dc0658
