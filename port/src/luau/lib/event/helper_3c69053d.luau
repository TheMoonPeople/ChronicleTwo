--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_214efeb6 = require("@lib/event/helper_214efeb6")
local helper_250176ca = require("@lib/event/helper_250176ca")
local helper_6cc276cf = require("@lib/event/helper_6cc276cf")
local helper_6d695576 = require("@lib/event/helper_6d695576")
local helper_eda48c65 = require("@lib/event/helper_eda48c65")

--- Helper function.
local function helper_3c69053d(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_eda48c65(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_214efeb6(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 6) or var3
	if var3 == 0 then
		helper_6cc276cf(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_250176ca(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_6d695576(arg0, arg1)
		return
	end
end

return helper_3c69053d
