--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_46e8aa48 = require("@lib/event/helper_46e8aa48")
local helper_6e247bd9 = require("@lib/event/helper_6e247bd9")
local helper_7ee99e81 = require("@lib/event/helper_7ee99e81")

--- Helper function.
local function helper_3ae9540d()
	local argc: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return 0
		end
		if at <= 2 then
			return helper_6e247bd9()
		end
		if at <= 3 then
			helper_7ee99e81(3, 1)
			helper_46e8aa48(3, -1, 3, 256, 208)
		end
		return helper_6e247bd9()
	end
	argc = event.GetItemHaveNum(355) or argc
	if argc <= 0 then
		helper_7ee99e81(3, 1)
		event.MesMake_2(3, "スクープメモを\n買ってくれ。")
		helper_46e8aa48(3, -1, 3, 256, 208)
		if vm.skipping() then
			return skip(1)
		end
		return 0
	end
	do
		local out1, out2 = event.GetMenuEtc_3(5)
		var1 = out1 or var1
		var2 = out2 or var2
	end
	if var1 == var2 then
		helper_7ee99e81(3, 1)
		event.MesMake_2(3, "もう、スクープは\nなさそうだな。")
		helper_46e8aa48(3, -1, 3, 256, 208)
		if vm.skipping() then
			return skip(2)
		end
		return helper_6e247bd9()
	end
	var3 = event.GetMenuEtc_2(3) or var3
	if 0 < var3 then
		helper_7ee99e81(3, 8)
		event.SetMesValue(3, 1, var3)
		event.MesMake_2(3, "スクープ条件が、[数値１]個\n明らかになった。")
		event.SetMesDrawspeed(3, 0)
		helper_46e8aa48(3, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
	end
	helper_7ee99e81(3, 1)
	var3 = event.GetMenuEtc_2(4) or var3
	if var3 <= 0 then
		event.MesMake_2(3, "なんだよ、スクープなんて\n撮れてないじゃないか。")
	else
		event.SetMesValue(3, 1, var3)
		event.MesMake_2(3, "お、[数値１]枚もスクープが\n撮れてるじゃん。さすがだな。")
	end
	helper_46e8aa48(3, -1, 3, 256, 208)
	if vm.skipping() then
		return skip(4)
	end
	return helper_6e247bd9()
end

return helper_3ae9540d
