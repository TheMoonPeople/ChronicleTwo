--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_125385ee = require("@lib/event/helper_125385ee")
local helper_a3cc6850 = require("@lib/event/helper_a3cc6850")
local helper_ee1c51d0 = require("@lib/event/helper_ee1c51d0")
local helper_fbd9683d = require("@lib/event/helper_fbd9683d")

--- Helper function.
local function helper_a7a78726()
	local var0: s32 = 0
	local var1: s32 = 0
	local at: number = 0
	return vm.guard(function()
		do
			local out1, out2 = event.GetMenuEtc_3(6)
			var0 = out1 or var0
			var1 = out2 or var1
		end
		if 0 < var0 then
			return 1
		end
		if var1 == 1 then
			helper_125385ee(3, 1)
			event.MesMake_2(3, "もっとスクープを撮って来ないと\n賞品はやれないぜ。")
			at = 1
			helper_a3cc6850(3, -1, 3, 256, 208)
		end
		if var1 == 2 then
			helper_125385ee(3, 1)
			event.MesMake_2(
				3,
				"ネタかスクープの数によって、\nオマエの写真家レベルが決まる。<page>レベルが上がれば、ごほうびの\nアイテムも増えるぞ。"
			)
			at = 2
			helper_a3cc6850(3, -1, 3, 256, 208)
		end
		return 0
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				helper_fbd9683d(3, 1)
				helper_ee1c51d0(3, -1, 3, 256, 208)
			end
			return 0
		end
		return nil
	end)
end

return helper_a7a78726
