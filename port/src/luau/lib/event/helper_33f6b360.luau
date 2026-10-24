--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_2380c1db = require("@lib/event/helper_2380c1db")
local helper_2832efea = require("@lib/event/helper_2832efea")
local helper_9ce38780 = require("@lib/event/helper_9ce38780")
local helper_b62118b5 = require("@lib/event/helper_b62118b5")
local helper_b63ef9c0 = require("@lib/event/helper_b63ef9c0")
local helper_f543df43 = require("@lib/event/helper_f543df43")

--- Helper function.
local function helper_33f6b360(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: f32 = 0
	local var6: f32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_b63ef9c0(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_b62118b5(arg0, arg1)
		return
	end
	do
		local out1, _, out3 = event.GetCharaPos(arg0)
		var4 = out1 or var4
		var6 = out3 or var6
	end
	if var4 < 1182.0 or 1183.0 < var4 or var6 < 210.0 or 211.0 < var6 then
		print("kokokokokokokokokoko\n")
		helper_2832efea(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 9) or var3
	if var3 == 0 then
		helper_f543df43(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_2380c1db(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_9ce38780(arg0, arg1)
		return
	end
end

return helper_33f6b360
