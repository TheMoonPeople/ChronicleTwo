--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_531648ab = require("@lib/event/helper_531648ab")
local helper_595fafd5 = require("@lib/event/helper_595fafd5")
local helper_62732cb5 = require("@lib/event/helper_62732cb5")
local helper_86b7f2bb = require("@lib/event/helper_86b7f2bb")
local helper_baac31ea = require("@lib/event/helper_baac31ea")
local helper_cf8cd98b = require("@lib/event/helper_cf8cd98b")
local helper_f6c140b6 = require("@lib/event/helper_f6c140b6")

--- Helper function.
local function helper_ad1f82a7(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_f6c140b6(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_86b7f2bb(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 7) or var3
	if var3 == 0 then
		helper_baac31ea(arg0, arg1)
		return
	end
	if var3 == 1 then
		var4 = event.GetCnt(8) or var4
		if var4 == 0 then
			helper_62732cb5(arg0, arg1)
		end
		if var4 == 1 then
			helper_595fafd5(arg0, arg1)
		end
		if var4 == 2 then
			helper_531648ab(arg0, arg1)
		end
		return
	end
	if var3 == 2 then
		helper_cf8cd98b(arg0, arg1)
		return
	end
end

return helper_ad1f82a7
