--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_0195cbc5 = require("@lib/event/helper_0195cbc5")
local helper_33b4d6ec = require("@lib/event/helper_33b4d6ec")
local helper_49d2a61d = require("@lib/event/helper_49d2a61d")
local helper_55025e00 = require("@lib/event/helper_55025e00")
local helper_58e1dabd = require("@lib/event/helper_58e1dabd")
local helper_a7ee1aa3 = require("@lib/event/helper_a7ee1aa3")
local helper_b384f485 = require("@lib/event/helper_b384f485")

--- Helper function.
local function helper_9d950616(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_49d2a61d(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_a7ee1aa3(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 7) or var3
	if var3 == 0 then
		helper_33b4d6ec(arg0, arg1)
		return
	end
	if var3 == 1 then
		var4 = event.GetCnt(8) or var4
		if var4 == 0 then
			helper_b384f485(arg0, arg1)
		end
		if var4 == 1 then
			helper_0195cbc5(arg0, arg1)
		end
		if var4 == 2 then
			helper_55025e00(arg0, arg1)
		end
		return
	end
	if var3 == 2 then
		helper_58e1dabd(arg0, arg1)
		return
	end
end

return helper_9d950616
