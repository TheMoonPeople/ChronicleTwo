--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_1459198e = require("@lib/event/helper_1459198e")
local helper_46c77ba6 = require("@lib/event/helper_46c77ba6")
local helper_7518fb0c = require("@lib/event/helper_7518fb0c")
local helper_c32dc32e = require("@lib/event/helper_c32dc32e")
local helper_e07f4edb = require("@lib/event/helper_e07f4edb")

--- Helper function.
local function helper_6266e5ea(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		helper_7518fb0c(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_1459198e(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 10) or var3
	if var3 == 0 then
		helper_c32dc32e(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_46c77ba6(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_e07f4edb(arg0, arg1)
		return
	end
end

return helper_6266e5ea
