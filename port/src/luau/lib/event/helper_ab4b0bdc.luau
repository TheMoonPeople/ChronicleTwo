--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_214efeb6 = require("@lib/event/helper_214efeb6")
local helper_37d28217 = require("@lib/event/helper_37d28217")
local helper_6d695576 = require("@lib/event/helper_6d695576")
local helper_eda48c65 = require("@lib/event/helper_eda48c65")
local helper_efc764c5 = require("@lib/event/helper_efc764c5")

--- Helper function.
local function helper_ab4b0bdc(arg0: s32, arg1: s32)
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
		helper_efc764c5(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_37d28217(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_6d695576(arg0, arg1)
		return
	end
end

return helper_ab4b0bdc
