--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1f64c8ad = require("@lib/event/helper_1f64c8ad")
local helper_24d1805d = require("@lib/event/helper_24d1805d")
local helper_f3a90693 = require("@lib/event/helper_f3a90693")

--- Helper function.
local function helper_bb68edd5(arg0: s32)
	local var1: any = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local active_chr_no: s32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var10: s32 = 0
	local active_chr_no_2: s32 = 0
	local max: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var2 = 0
			var2 = 0
			var2 = 0
			var2 = 1
			var3 = 8
			var4 = 1
			var3 = var3 * 2
			var4 = var4 + 1
			helper_f3a90693(0, 2213, 5, 0, 0)
		end
		if at <= 2 then
			var2 = 0
			helper_f3a90693(0, 2215, 5, 0, 0)
		end
		if at <= 3 then
			helper_f3a90693(0, 2216, 5, 0, 0)
		end
		if at <= 4 then
			var2 = 1
			helper_f3a90693(0, 2211, 5, 0, 0)
		end
		if at <= 5 then
			var2 = 1
			active_chr_no_2 = 1
			helper_f3a90693(0, 2212, 5, 0, 0)
		end
		var2 = 1
		return var2, arg0
	end
	helper_24d1805d(0, 2200, 5, 0, 0)
	var1 = helper_1f64c8ad(0, 4, 4, 0)
	if vm.skipping() then
		return skip(1)
	end
	if var1 == 1 then
		var2 = 0
	end
	if var1 == 2 then
		var2 = 0
	end
	if var1 == 3 then
		var2 = 0
	end
	if var1 == -1 or var1 == 4 then
		var2 = 1
	end
	if var2 ~= 1 then
		var3 = 8
		var4 = 1
		while var4 < var1 do
			var3 = vm.i32(var3 * 2)
			var4 = vm.i32(var4 + 1)
		end
		event.SetMesQuestionGyou(0, 0)
		if vm.i32(bit32.band(arg0, var3)) ~= 0 then
			helper_f3a90693(0, 2213, 5, 0, 0)
			if vm.skipping() then
				return skip(2)
			end
			var2 = 0
		else
			event.SysSePlay(24)
			if bit32.band(arg0, 8) ~= 0 then
				active_chr_no = event.GetActiveChrNo() or active_chr_no
				if active_chr_no == 0 or active_chr_no == 2 then
					helper_f3a90693(0, 2215, 5, 0, 0)
					if vm.skipping() then
						return skip(3)
					end
					event.SetCharaCondition(0, 1, 0)
					event.AddHpRate2(0, -0.7)
				else
					helper_f3a90693(0, 2216, 5, 0, 0)
					if vm.skipping() then
						return skip(4)
					end
					event.SetCharaCondition(1, 1, 0)
					event.AddHpRate2(1, -0.7)
				end
				var2 = 1
			end
			if bit32.band(arg0, 16) ~= 0 then
				helper_f3a90693(0, 2211, 5, 0, 0)
				if vm.skipping() then
					return skip(5)
				end
				event.SetTbStatus(0)
				do
					local out1, out2, out3, _ = event.GetDunWorldCoord(1)
					var6 = out1 or var6
					var7 = out2 or var7
					var8 = out3 or var8
				end
				var10 = event.GetSndId(4) or var10
				event.SndSePlay(var10, 11)
				event.DngCreateEffect("爆発", var6, var7 + 4.0, var8, 5)
				var2 = 1
			end
			if bit32.band(arg0, 32) ~= 0 then
				active_chr_no_2 = event.GetActiveChrNo() or active_chr_no_2
				if active_chr_no_2 == 3 then
					active_chr_no_2 = 1
				end
				event.UdataAddWhp(active_chr_no_2, 0, -999)
				event.UdataAddWhp(active_chr_no_2, 1, -999)
				do
					local _, out2 = event.UdataGetAbs(active_chr_no_2, 0)
					max = out2 or max
				end
				event.UdataAddAbs(active_chr_no_2, 0, vm.idiv(vm.i32(-max), 10))
				do
					local _, out2 = event.UdataGetAbs(active_chr_no_2, 1)
					max = out2 or max
				end
				event.UdataAddAbs(active_chr_no_2, 1, vm.idiv(vm.i32(-max), 10))
				helper_f3a90693(0, 2212, 5, 0, 0)
				if vm.skipping() then
					return skip(6)
				end
				var2 = 1
			end
		end
	end
	return var2, arg0
end

return helper_bb68edd5
