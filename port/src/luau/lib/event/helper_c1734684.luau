--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_30ed1f1b = require("@lib/event/helper_30ed1f1b")
local helper_41ab20a2 = require("@lib/event/helper_41ab20a2")
local helper_434d8c41 = require("@lib/event/helper_434d8c41")
local helper_7d487490 = require("@lib/event/helper_7d487490")
local helper_d3d9a98c = require("@lib/event/helper_d3d9a98c")
local helper_f2709c42 = require("@lib/event/helper_f2709c42")

--- Helper function.
local function helper_c1734684(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: f32 = 0
	local var6: f32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_30ed1f1b(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_d3d9a98c(arg0, arg1)
		return
	end
	do
		local out1, _, out3 = event.GetCharaPos(arg0)
		var4 = out1 or var4
		var6 = out3 or var6
	end
	if var4 < 1182.0 or 1183.0 < var4 or var6 < 210.0 or 211.0 < var6 then
		print("kokokokokokokokokoko\n")
		helper_41ab20a2(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 9) or var3
	if var3 == 0 then
		helper_f2709c42(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_434d8c41(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_7d487490(arg0, arg1)
		return
	end
end

return helper_c1734684
