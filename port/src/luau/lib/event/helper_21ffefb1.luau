--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_125385ee = require("@lib/event/helper_125385ee")
local helper_a3cc6850 = require("@lib/event/helper_a3cc6850")
local helper_a530b474 = require("@lib/event/helper_a530b474")
local helper_a7a78726 = require("@lib/event/helper_a7a78726")
local helper_ee1c51d0 = require("@lib/event/helper_ee1c51d0")
local helper_fbd9683d = require("@lib/event/helper_fbd9683d")

--- Helper function.
local function helper_21ffefb1()
	local argc: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local at: number = 0
	return vm.guard(function()
		argc = event.GetItemHaveNum(355) or argc
		if argc <= 0 then
			helper_125385ee(3, 1)
			event.MesMake_2(3, "スクープメモを\n買ってくれ。")
			at = 1
			helper_a3cc6850(3, -1, 3, 256, 208)
			return 0
		end
		do
			local out1, out2 = event.GetMenuEtc_3(5)
			var1 = out1 or var1
			var2 = out2 or var2
		end
		if var1 == var2 then
			helper_125385ee(3, 1)
			event.MesMake_2(3, "もう、スクープは\nなさそうだな。")
			at = 2
			helper_a3cc6850(3, -1, 3, 256, 208)
			at = 3
			return helper_a7a78726()
		end
		var3 = event.GetMenuEtc_2(3) or var3
		if 0 < var3 then
			helper_125385ee(3, 8)
			event.SetMesValue(3, 1, var3)
			event.MesMake_2(3, "スクープ条件が、[数値１]個\n明らかになった。")
			event.SetMesDrawspeed(3, 0)
			at = 4
			helper_a3cc6850(3, -1, 8, 0, 0)
		end
		helper_125385ee(3, 1)
		var3 = event.GetMenuEtc_2(4) or var3
		if var3 <= 0 then
			event.MesMake_2(3, "なんだよ、スクープなんて\n撮れてないじゃないか。")
		else
			event.SetMesValue(3, 1, var3)
			event.MesMake_2(3, "お、[数値１]枚もスクープが\n撮れてるじゃん。さすがだな。")
		end
		at = 5
		helper_a3cc6850(3, -1, 3, 256, 208)
		at = 6
		return helper_a7a78726()
	end, function(received: { any })
		if at <= 1 then
			return 0
		end
		if at <= 3 then
			return helper_a530b474()
		end
		if at <= 6 then
			if at <= 4 then
				helper_fbd9683d(3, 1)
				helper_ee1c51d0(3, -1, 3, 256, 208)
			end
			return helper_a530b474()
		end
		return nil
	end)
end

return helper_21ffefb1
