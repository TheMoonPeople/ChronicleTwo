--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_2c538d57 = require("@lib/event/helper_2c538d57")
local helper_7975f386 = require("@lib/event/helper_7975f386")
local helper_8ac5c287 = require("@lib/event/helper_8ac5c287")
local helper_8b5773f5 = require("@lib/event/helper_8b5773f5")
local helper_dea6158d = require("@lib/event/helper_dea6158d")
local helper_e7e39d5f = require("@lib/event/helper_e7e39d5f")

--- Helper function.
local function helper_1af32d6e(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: f32 = 0
	local var6: f32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_7975f386(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_2c538d57(arg0, arg1)
		return
	end
	do
		local out1, _, out3 = event.GetCharaPos(arg0)
		var4 = out1 or var4
		var6 = out3 or var6
	end
	if var4 < 1182.0 or 1183.0 < var4 or var6 < 210.0 or 211.0 < var6 then
		print("kokokokokokokokokoko\n")
		helper_dea6158d(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 9) or var3
	if var3 == 0 then
		helper_8ac5c287(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_8b5773f5(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_e7e39d5f(arg0, arg1)
		return
	end
end

return helper_1af32d6e
