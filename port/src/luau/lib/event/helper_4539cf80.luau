--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_29de2054 = require("@lib/event/helper_29de2054")
local helper_3691a72d = require("@lib/event/helper_3691a72d")
local helper_91b773b6 = require("@lib/event/helper_91b773b6")
local helper_f33d3edc = require("@lib/event/helper_f33d3edc")

--- Helper function.
local function helper_4539cf80(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local flag: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	flag = event.GetFlag(424) or flag
	if var2 ~= 2 or flag == 0 then
		helper_f33d3edc(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 16) or var2
	if var2 == 0 then
		helper_91b773b6(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_3691a72d(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_29de2054(arg0, arg1)
		return
	end
end

return helper_4539cf80
