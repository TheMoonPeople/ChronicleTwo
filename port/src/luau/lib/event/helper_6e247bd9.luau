--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_46e8aa48 = require("@lib/event/helper_46e8aa48")
local helper_7ee99e81 = require("@lib/event/helper_7ee99e81")

--- Helper function.
local function helper_6e247bd9()
	local var0: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return 1
		end
		if at <= 2 then
			helper_7ee99e81(3, 1)
			helper_46e8aa48(3, -1, 3, 256, 208)
		end
		return 0
	end
	if vm.skipping() then
		return skip(1)
	end
	do
		local out1, out2 = event.GetMenuEtc_3(6)
		var0 = out1 or var0
		var1 = out2 or var1
	end
	if 0 < var0 then
		return 1
	end
	if var1 == 1 then
		helper_7ee99e81(3, 1)
		event.MesMake_2(3, "もっとスクープを撮って来ないと\n賞品はやれないぜ。")
		helper_46e8aa48(3, -1, 3, 256, 208)
		if vm.skipping() then
			return skip(2)
		end
	end
	if var1 == 2 then
		helper_7ee99e81(3, 1)
		event.MesMake_2(
			3,
			"ネタかスクープの数によって、\nオマエの写真家レベルが決まる。<page>レベルが上がれば、ごほうびの\nアイテムも増えるぞ。"
		)
		helper_46e8aa48(3, -1, 3, 256, 208)
		if vm.skipping() then
			return skip(3)
		end
	end
	return 0
end

return helper_6e247bd9
