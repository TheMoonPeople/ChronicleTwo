--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_33a348a7 = require("@lib/event/helper_33a348a7")
local helper_3e69da2c = require("@lib/event/helper_3e69da2c")
local helper_e5219064 = require("@lib/event/helper_e5219064")
local helper_eb560126 = require("@lib/event/helper_eb560126")

--- Helper function.
local function helper_30c3af0c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_3e69da2c(arg0, arg1)
			end
			return
		end
		if at <= 6 then
			if at <= 4 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			if at <= 5 then
				helper_3e69da2c(arg0, arg1)
			end
			return
		end
		if at <= 9 then
			if at <= 7 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			if at <= 8 then
				helper_3e69da2c(arg0, arg1)
			end
			return
		end
		if at <= 13 then
			if at <= 10 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			if at <= 11 then
				helper_e5219064(0, -1, arg0, arg1, 0)
			end
			if at <= 12 then
				helper_3e69da2c(arg0, arg1)
			end
			return
		end
		if at <= 14 then
			helper_e5219064(0, -1, arg0, arg1, 0)
		end
		if at <= 15 then
			helper_33a348a7()
		end
	end
	do
		local out1, out2, out3, out4 = event.Stopwatch_5(1)
		var2 = out1 or var2
		var3 = out2 or var3
		var4 = out3 or var4
		var5 = out4 or var5
	end
	event.SetMesPreset(0, 0)
	helper_eb560126(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var6 = event.GetCnt(7) or var6
	if var6 == 0 then
		event.MesMake_2(0, "Hallo, Max.\nWillst du nochmal probieren?")
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		helper_3e69da2c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var6 == 1 then
		event.MesMake_2(0, "He! Du warst nicht beim Boot,\noder? Du wolltest mich\ndrankriegen! Mogeln gilt nicht.")
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.MesMake_2(0, "Versuchst du's noch mal?")
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(5)
		end
		helper_3e69da2c(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
	if var2 < 0 then
		event.MesMake_2(0, "He, nicht mogeln!")
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(7)
		end
		event.MesMake_2(0, "Versuchst du's noch mal?")
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(8)
		end
		helper_3e69da2c(arg0, arg1)
		if vm.skipping() then
			return skip(9)
		end
		return
	end
	event.MesMake_2(0, "Oh, da bist du ja wieder!\nGut,<page>sehen wir mal\nnach der Zeit!")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(10)
	end
	event.SetMesValue(0, 1, var2)
	event.SetMesValue(0, 2, var3)
	event.SetMesValue(0, 3, var4)
	if var5 == 0 then
		event.MesMake_2(0, "Oh Mann!\n[数値１] Min. [数値２] Sek. [数値３] ist\nzu langsam.")
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(11)
		end
		event.MesMake_2(0, "Versuchst du's noch mal?")
		helper_e5219064(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(12)
		end
		helper_3e69da2c(arg0, arg1)
		if vm.skipping() then
			return skip(13)
		end
		return
	end
	event.MesMake_2(0, "Oh!\n[数値１] Min. [数値２] Sek. [数値３]\nist keine schlechte Zeit!")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(14)
	end
	event.MesMake_2(0, "Du bist schneller als du aussiehst.\nDann verm[UNI00f6]beln wir zusammen\ndie Fieslinge!")
	helper_e5219064(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(15)
	end
	event.SetMotion(arg0, "立ち")
	helper_33a348a7()
	if vm.skipping() then
		return skip(16)
	end
	event.Finish()
	event.SetQuestEtc(1, 9, 1)
end

return helper_30c3af0c
