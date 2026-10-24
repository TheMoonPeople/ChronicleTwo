--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_00f295c0 = require("@lib/event/helper_00f295c0")
local helper_11504317 = require("@lib/event/helper_11504317")
local helper_3192670f = require("@lib/event/helper_3192670f")
local helper_4f6042d7 = require("@lib/event/helper_4f6042d7")
local helper_d9a34a01 = require("@lib/event/helper_d9a34a01")

--- Helper function.
local function helper_77464c6c(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_4f6042d7(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_d9a34a01(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 8) or var3
	if var3 == 0 then
		helper_11504317(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_00f295c0(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_3192670f(arg0, arg1)
		return
	end
end

return helper_77464c6c
