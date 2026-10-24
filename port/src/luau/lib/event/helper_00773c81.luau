--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_29de2054 = require("@lib/event/helper_29de2054")
local helper_de1a2a7e = require("@lib/event/helper_de1a2a7e")
local helper_f33d3edc = require("@lib/event/helper_f33d3edc")
local helper_ff3b3654 = require("@lib/event/helper_ff3b3654")

--- Helper function.
local function helper_00773c81(arg0: s32, arg1: s32)
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
		helper_de1a2a7e(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_ff3b3654(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_29de2054(arg0, arg1)
		return
	end
end

return helper_00773c81
