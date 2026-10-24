--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1dc369a0 = require("@lib/event/helper_1dc369a0")
local helper_26d4fde0 = require("@lib/event/helper_26d4fde0")
local helper_55bad942 = require("@lib/event/helper_55bad942")
local helper_a3bafe46 = require("@lib/event/helper_a3bafe46")
local helper_b1338111 = require("@lib/event/helper_b1338111")
local helper_fdffeda5 = require("@lib/event/helper_fdffeda5")

--- Helper function.
local function helper_fd87c7a3(arg0: s32)
	local var1: any = 0
	local var2: s32 = 0
	local now_party_chara_id: s32 = 0
	local var4: s32 = 0
	local active_chr_no: s32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var10: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b1338111(0, -1, 5, 0, 0)
		end
		if at <= 2 then
			arg0 = helper_26d4fde0(arg0, 2)
			var2 = 0
			helper_a3bafe46(6)
		end
		if at <= 4 then
			arg0 = helper_26d4fde0(arg0, 2)
			var2 = 0
			var2 = 1
			helper_1dc369a0()
		end
		if at <= 5 then
			var2 = 1
			helper_b1338111(0, 2215, 5, 0, 0)
		end
		if at <= 6 then
			helper_b1338111(0, 2216, 5, 0, 0)
		end
		if at <= 7 then
			var2 = 0
			helper_b1338111(0, 2211, 5, 0, 0)
		end
		if at <= 8 then
			var2 = 1
			helper_b1338111(0, 2212, 5, 0, 0)
		end
		var2 = 0
		arg0 = helper_26d4fde0(arg0, 2)
		var2 = 1
		return var2, arg0
	end
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	if now_party_chara_id == 4 then
		event.MesMake_2(
			0,
			"宝箱にはカギがかかっているようだ。\nドニーに開けてもらう。\n強引に開けてみる。\nあきらめる。"
		)
		helper_fdffeda5(0, -1, 5, 0, 0)
	else
		helper_fdffeda5(0, 2220, 5, 0, 0)
	end
	var1 = helper_55bad942(0, 3, 3, 0)
	if vm.skipping() then
		return skip(1)
	end
	if var1 == 1 then
		if now_party_chara_id == 4 then
			event.MesMake_2(0, "ドニー「よし！まかせろ！！」")
			helper_b1338111(0, -1, 5, 0, 0)
			if vm.skipping() then
				return skip(2)
			end
			arg0 = helper_26d4fde0(arg0, 2)
			var2 = 0
		else
			event.SetStatusbarShow(0, 0.16666667)
			helper_a3bafe46(6)
			if vm.skipping() then
				return skip(3)
			end
			event.GotoUseItem(297)
			do
				local skipped = vm.wait()
				var4 = event.DeferredOutput() or var4
				if skipped then
					return skip(4)
				end
			end
			if var4 == 297 then
				arg0 = helper_26d4fde0(arg0, 2)
				var2 = 0
			elseif var4 <= 0 then
				var2 = 1
			else
				helper_1dc369a0()
				if vm.skipping() then
					return skip(5)
				end
				var2 = 1
			end
			event.SetStatusbarShow(1, 0.16666667)
		end
	end
	if var1 == 2 then
		event.SysSePlay(24)
		event.SetMesQuestionGyou(0, 0)
		if bit32.band(arg0, 8) ~= 0 then
			active_chr_no = event.GetActiveChrNo() or active_chr_no
			if active_chr_no == 0 or active_chr_no == 2 then
				helper_b1338111(0, 2215, 5, 0, 0)
				if vm.skipping() then
					return skip(6)
				end
				event.SetCharaCondition(0, 1, 0)
				event.AddHpRate2(0, -0.7)
			else
				helper_b1338111(0, 2216, 5, 0, 0)
				if vm.skipping() then
					return skip(7)
				end
				event.SetCharaCondition(1, 1, 0)
				event.AddHpRate2(1, -0.7)
			end
			var2 = 0
		end
		if bit32.band(arg0, 16) ~= 0 then
			helper_b1338111(0, 2211, 5, 0, 0)
			if vm.skipping() then
				return skip(8)
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
			helper_b1338111(0, 2212, 5, 0, 0)
			if vm.skipping() then
				return skip(9)
			end
			event.AddWhp(0, -999)
			event.AddWhp(1, -999)
			var2 = 0
		end
		arg0 = helper_26d4fde0(arg0, 2)
	end
	if var1 == -1 or var1 == 3 then
		var2 = 1
	end
	return var2, arg0
end

return helper_fd87c7a3
