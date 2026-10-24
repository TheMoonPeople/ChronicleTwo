--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_088714b0 = require("@lib/event/helper_088714b0")
local helper_61afd6a2 = require("@lib/event/helper_61afd6a2")
local helper_9a4c0658 = require("@lib/event/helper_9a4c0658")
local helper_a3aca423 = require("@lib/event/helper_a3aca423")
local helper_d845f61e = require("@lib/event/helper_d845f61e")

--- Helper function.
local function helper_0b998b84(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_9a4c0658(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_a3aca423(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 8) or var3
	if var3 == 0 then
		helper_d845f61e(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_088714b0(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_61afd6a2(arg0, arg1)
		return
	end
end

return helper_0b998b84
