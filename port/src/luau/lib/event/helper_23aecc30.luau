--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_1680542e = require("@lib/event/helper_1680542e")
local helper_410c2528 = require("@lib/event/helper_410c2528")
local helper_5cec003b = require("@lib/event/helper_5cec003b")
local helper_b5252af7 = require("@lib/event/helper_b5252af7")
local helper_d40279f7 = require("@lib/event/helper_d40279f7")

--- Helper function.
local function helper_23aecc30(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		helper_1680542e(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_5cec003b(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 10) or var3
	if var3 == 0 then
		helper_d40279f7(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_410c2528(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_b5252af7(arg0, arg1)
		return
	end
end

return helper_23aecc30
