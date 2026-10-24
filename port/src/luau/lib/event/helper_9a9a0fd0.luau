--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_5bc89571 = require("@lib/event/helper_5bc89571")
local helper_800e4569 = require("@lib/event/helper_800e4569")
local helper_a8eaec59 = require("@lib/event/helper_a8eaec59")
local helper_c5663c3c = require("@lib/event/helper_c5663c3c")
local helper_ec84d16f = require("@lib/event/helper_ec84d16f")
local helper_f0db3082 = require("@lib/event/helper_f0db3082")
local helper_f432f3aa = require("@lib/event/helper_f432f3aa")

--- Helper function.
local function helper_9a9a0fd0(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_f0db3082(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_a8eaec59(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 7) or var3
	if var3 == 0 then
		helper_5bc89571(arg0, arg1)
		return
	end
	if var3 == 1 then
		var4 = event.GetCnt(8) or var4
		if var4 == 0 then
			helper_c5663c3c(arg0, arg1)
		end
		if var4 == 1 then
			helper_ec84d16f(arg0, arg1)
		end
		if var4 == 2 then
			helper_f432f3aa(arg0, arg1)
		end
		return
	end
	if var3 == 2 then
		helper_800e4569(arg0, arg1)
		return
	end
end

return helper_9a9a0fd0
