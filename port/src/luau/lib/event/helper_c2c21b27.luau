--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_0bcde91a = require("@lib/event/helper_0bcde91a")
local helper_2878d1a6 = require("@lib/event/helper_2878d1a6")
local helper_38f0fb09 = require("@lib/event/helper_38f0fb09")
local helper_5e3b17e4 = require("@lib/event/helper_5e3b17e4")
local helper_a5e64086 = require("@lib/event/helper_a5e64086")
local helper_eae1b8c2 = require("@lib/event/helper_eae1b8c2")

--- Helper function.
local function helper_c2c21b27(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: f32 = 0
	local var6: f32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_38f0fb09(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_eae1b8c2(arg0, arg1)
		return
	end
	do
		local out1, _, out3 = event.GetCharaPos(arg0)
		var4 = out1 or var4
		var6 = out3 or var6
	end
	if var4 < 1182.0 or 1183.0 < var4 or var6 < 210.0 or 211.0 < var6 then
		print("kokokokokokokokokoko\n")
		helper_5e3b17e4(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 9) or var3
	if var3 == 0 then
		helper_2878d1a6(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_a5e64086(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_0bcde91a(arg0, arg1)
		return
	end
end

return helper_c2c21b27
