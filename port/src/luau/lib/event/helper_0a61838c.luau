--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_485a0223 = require("@lib/event/helper_485a0223")
local helper_4ccbfbc3 = require("@lib/event/helper_4ccbfbc3")
local helper_5f40665a = require("@lib/event/helper_5f40665a")
local helper_6aaefaf5 = require("@lib/event/helper_6aaefaf5")
local helper_aa1347b7 = require("@lib/event/helper_aa1347b7")
local helper_f45eb24b = require("@lib/event/helper_f45eb24b")

--- Helper function.
local function helper_0a61838c(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: f32 = 0
	local var6: f32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_485a0223(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_6aaefaf5(arg0, arg1)
		return
	end
	do
		local out1, _, out3 = event.GetCharaPos(arg0)
		var4 = out1 or var4
		var6 = out3 or var6
	end
	if var4 < 1182.0 or 1183.0 < var4 or var6 < 210.0 or 211.0 < var6 then
		print("kokokokokokokokokoko\n")
		helper_aa1347b7(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 9) or var3
	if var3 == 0 then
		helper_f45eb24b(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_4ccbfbc3(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_5f40665a(arg0, arg1)
		return
	end
end

return helper_0a61838c
