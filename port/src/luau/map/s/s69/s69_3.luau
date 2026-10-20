--!strict
-- map/s/s69/s69_3.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_093c85e9 = require("@lib/event/helper_093c85e9")
local helper_1388d2a9 = require("@lib/event/helper_1388d2a9")
local helper_18ada31e = require("@lib/event/helper_18ada31e")
local helper_20c72d9f = require("@lib/event/helper_20c72d9f")
local helper_3aa6bc4f = require("@lib/event/helper_3aa6bc4f")
local helper_4457cf9b = require("@lib/event/helper_4457cf9b")
local helper_5dbff6db = require("@lib/event/helper_5dbff6db")
local helper_60845124 = require("@lib/event/helper_60845124")
local helper_68fde5f8 = require("@lib/event/helper_68fde5f8")
local helper_9660e7cc = require("@lib/event/helper_9660e7cc")
local helper_9ac5c278 = require("@lib/event/helper_9ac5c278")
local helper_9fa762c4 = require("@lib/event/helper_9fa762c4")
local helper_a2e87194 = require("@lib/event/helper_a2e87194")
local helper_ac82f7c0 = require("@lib/event/helper_ac82f7c0")
local helper_bf9857b2 = require("@lib/event/helper_bf9857b2")
local helper_cc3c3399 = require("@lib/event/helper_cc3c3399")
local helper_d163dbd7 = require("@lib/event/helper_d163dbd7")
local helper_dc16211f = require("@lib/event/helper_dc16211f")
local helper_dc405d6a = require("@lib/event/helper_dc405d6a")
local helper_e350e692 = require("@lib/event/helper_e350e692")
local helper_ec9ebfb2 = require("@lib/event/helper_ec9ebfb2")

--- Program 99.
local function program_99()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_093c85e9()
		end
	end
	event.StopBgm(0)
	event.LoadSound(8694)
	var0 = event.GetCnt(17) or var0
	if bit32.band(var0, 256) == 0 or bit32.band(var0, 512) == 0 then
		event.StopBgm(0)
		helper_cc3c3399(4)
		if vm.skipping() then
			return skip(1)
		end
		event.LoadBgm(190)
		event.PlayBgm(0)
	else
		event.SetLoadbgFile("snd2/bgm/bg_193.sound.json")
		helper_093c85e9()
		if vm.skipping() then
			return skip(2)
		end
		event.LoadBgmPack(193)
		event.PlayBgm(0)
	end
end

--- Helper function.
local function helper_28f0c()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local block: s32 = 0
	local value: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 5 then
			if at <= 2 then
				var0 = 0
				var0 = var0 + 1
				var0 = 0
				var0 = var0 + 1
				helper_cc3c3399(3)
			end
			if at <= 3 then
				var0 = 0
				value = 0
				var0 = var0 + 1
				helper_cc3c3399(60)
			end
			if at <= 4 then
				helper_cc3c3399(30)
			end
			if vm.skip_end() then
				return skip(6)
			end
			return part2()
		end
		var0 = 0
		var0 = var0 + 1
	end
	function part2()
		event.CancelDramaScene()
		event.CharaActive(1, 0)
		event.SetCharaPos(0, var2, var3, var4)
		var0 = 0
		while var0 < 6 do
			event.DeleteChara(8 + var0)
			var0 = var0 + 1
		end
		event.SpriteSetDraw(0, 0)
		event.DelImg(0)
		event.SetFadeIn(30)
		event.Finish()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	if vm.wait() then
		return skip(2)
	end
	var1 = event.SndLoadSound(5, "snd2/mon/en_008.sound.json") or var1
	event.AssignStack(5)
	event.ClearStack(5)
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var2 = out1 or var2
		var3 = out2 or var3
		var4 = out3 or var4
	end
	event.SetCharaPos(0, 0.0, -500.0, 0.0)
	event.CharaActive(0, 0)
	event.ChangeDir("dungeon/monster/")
	event.LoadChara(5, "e216d.gltf", "e216d", 8)
	event.CopyChara(5, 8, 9)
	event.CopyChara(5, 8, 10)
	event.CopyChara(5, 8, 11)
	event.CopyChara(5, 8, 12)
	event.CopyChara(5, 8, 13)
	var0 = 0
	while var0 < 6 do
		event.CharaActive(1, 8 + var0)
		event.EohSyncChara(0 + var0, 8 + var0)
		event.ObjsInit(0 + var0)
		event.ObjsSyncObj(0 + var0, 0 + var0)
		event.EohSetSoundId(0 + var0, var1)
		var0 = var0 + 1
	end
	event.ChangeDir("")
	block = event.LoadImg_4(5, "textures/event/e800/d07domari/d07domari04_1.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "d07domari04", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 128)
	event.SpriteSetPutsize(0, 512, 128)
	event.SpriteSetPos(0, 256, 312)
	event.SpriteSetDraw(0, 1)
	event.EohSyncSprite(7, 0)
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 7)
	event.InitDramaScene()
	event.SetFadeIn(30)
	event.CmrsSetPos(-6.98, 27.91, 53.33)
	event.CmrsSetRef(-8.01, 27.08, 94.1)
	var0 = 0
	while var0 < 6 do
		event.ObjsSetPos(0 + var0, -36.58, 0.0, 153.99)
		event.ObjsSetRot(0 + var0, 0.0, 2.92, 0.0)
		event.ObjsSetMotion(0 + var0, "立ち", 0)
		var0 = var0 + 1
	end
	helper_cc3c3399(3)
	if vm.skipping() then
		return skip(3)
	end
	var0 = 0
	while var0 < 6 do
		value = 0
		value = event.GetRandInt(6) or value
		event.ObjsMotionDelay(0 + var0, value)
		event.ObjsSetMotion(0 + var0, "攻撃１in", 6)
		event.ObjsNextMotion(0 + var0, "攻撃１", 0)
		var0 = var0 + 1
	end
	event.ObjsSetPos(0, -36.79, 0.0, 159.0)
	event.ObjsSetRot(0, 0.0, 2.92, 0.0)
	event.ObjsSetPos(1, 11.2, 0.0, 157.85)
	event.ObjsSetRot(1, 0.0, -3.0, 0.0)
	event.ObjsSetPos(2, 32.03, 0.0, 188.36)
	event.ObjsSetRot(2, 0.0, -3.0, 0.0)
	event.ObjsSetPos(3, 1.69, 0.0, 190.41)
	event.ObjsSetRot(3, 0.0, 3.04, 0.0)
	event.ObjsSetPos(4, -28.34, 0.0, 194.95)
	event.ObjsSetRot(4, 0.0, 2.92, 0.0)
	event.ObjsSetPos(5, -59.81, 0.0, 198.15)
	event.ObjsSetRot(5, 0.0, 2.92, 0.0)
	event.ObjsSetColor(7, 128, 128, 128, 128, 30)
	helper_cc3c3399(60)
	if vm.skipping() then
		return skip(4)
	end
	event.SetFadeOut(30)
	helper_cc3c3399(30)
	if vm.skipping() then
		return skip(5)
	end
	return part2()
end

--- Helper function.
local function helper_2a734()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.LoadMonsterFile(55, 1)
	event.AutoSetMonster(55, 50.54, 0.0, 460.31, -2.67)
	event.AutoSetMonster(55, -117.51, 0.0, 458.13, 2.77)
	event.AutoSetMonster(55, -144.84, 0.0, 606.65, 2.77)
	event.AutoSetMonster(55, -73.47, 0.0, 646.59, 3.13)
	event.AutoSetMonster(55, -16.67, 0.0, 634.86, 3.13)
	event.AutoSetMonster(55, 133.4, 0.0, 600.46, -2.91)
	event.DngPause(16384, 1)
end

--- Helper function.
local function helper_1b204(arg0: s32, arg1: s32)
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_cc3c3399(36)
		end
	end
	event.Initialize()
	event.DngPause(513, 1)
	event.SetCrossfade(15)
	event.SetTbStatus(0)
	event.CharaActive(0, 0)
	event.AssignStack(5)
	event.ClearStack(5)
	do
		local out1, out2, out3, out4 = event.GetDunWorldCoord(1)
		var2 = out1 or var2
		var3 = out2 or var3
		var4 = out3 or var4
		var5 = out4 or var5
	end
	event.SetWorldCoord(var2, var3, var4, var5)
	event.CopyMons2scnchr(5, arg0, 12)
	event.CharaActive(12)
	event.SetCharaPos(12, var2, var3, var4)
	event.SetCharaRot(12, 0.0, var5, 0.0)
	event.SetMotion(12, "閉め", 4)
	event.CmrsInit()
	event.CmrsSetPos(0.0, 29.0, 57.0)
	event.CmrsSetRef(0.0, 10.0, 0.0)
	event.CmrsMove(0.0, 22.27, 41.0, 0.0, 14.27, 0.0, 80)
	helper_cc3c3399(15)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMotion(12, "出現", 6)
	helper_cc3c3399(36)
	if vm.skipping() then
		return skip(2)
	end
	event.DeleteChara(12, 0)
	event.CharaActive(0, 12)
	event.AutoSetMonster(arg0, var2, var3, var4, 0.0, var5, 0.0, arg1)
	event.CharaActive(1, 0)
	event.DngPause(513, 0)
	event.Finish()
end

--- Helper function.
local function helper_1952c(arg0: s32)
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
			helper_20c72d9f(0, -1, 5, 0, 0)
		end
		if at <= 2 then
			arg0 = helper_60845124(arg0, 2)
			var2 = 0
			helper_cc3c3399(6)
		end
		if at <= 4 then
			arg0 = helper_60845124(arg0, 2)
			var2 = 0
			var2 = 1
			helper_3aa6bc4f()
		end
		if at <= 5 then
			var2 = 1
			helper_20c72d9f(0, 2215, 5, 0, 0)
		end
		if at <= 6 then
			helper_20c72d9f(0, 2216, 5, 0, 0)
		end
		if at <= 7 then
			var2 = 0
			helper_20c72d9f(0, 2211, 5, 0, 0)
		end
		if at <= 8 then
			var2 = 1
			helper_20c72d9f(0, 2212, 5, 0, 0)
		end
		var2 = 0
		arg0 = helper_60845124(arg0, 2)
		var2 = 1
		return var2, arg0
	end
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	if now_party_chara_id == 4 then
		event.MesMake_2(
			0,
			"Die Truhe ist wohl verschlossen.\nDonny soll sie [UNI00f6]ffnen.\nAufbrechen.\nVergiss sie."
		)
		helper_9ac5c278(0, -1, 5, 0, 0)
	else
		helper_9ac5c278(0, 2220, 5, 0, 0)
	end
	var1 = helper_ac82f7c0(0, 3, 3, 0)
	if vm.skipping() then
		return skip(1)
	end
	if var1 == 1 then
		if now_party_chara_id == 4 then
			event.MesMake_2(0, "O. K., [UNI00fc]berlass das mir!")
			helper_20c72d9f(0, -1, 5, 0, 0)
			if vm.skipping() then
				return skip(2)
			end
			arg0 = helper_60845124(arg0, 2)
			var2 = 0
		else
			event.SetStatusbarShow(0, 0.16666667)
			helper_cc3c3399(6)
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
				arg0 = helper_60845124(arg0, 2)
				var2 = 0
			elseif var4 <= 0 then
				var2 = 1
			else
				helper_3aa6bc4f()
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
				helper_20c72d9f(0, 2215, 5, 0, 0)
				if vm.skipping() then
					return skip(6)
				end
				event.SetCharaCondition(0, 1, 0)
				event.AddHpRate2(0, -0.7)
			else
				helper_20c72d9f(0, 2216, 5, 0, 0)
				if vm.skipping() then
					return skip(7)
				end
				event.SetCharaCondition(1, 1, 0)
				event.AddHpRate2(1, -0.7)
			end
			var2 = 0
		end
		if bit32.band(arg0, 16) ~= 0 then
			helper_20c72d9f(0, 2211, 5, 0, 0)
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
			helper_20c72d9f(0, 2212, 5, 0, 0)
			if vm.skipping() then
				return skip(9)
			end
			event.AddWhp(0, -999)
			event.AddWhp(1, -999)
			var2 = 0
		end
		arg0 = helper_60845124(arg0, 2)
	end
	if var1 == -1 or var1 == 3 then
		var2 = 1
	end
	return var2, arg0
end

--- Helper function.
local function helper_1a3c4(arg0: s32)
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
			helper_20c72d9f(0, 2213, 5, 0, 0)
		end
		if at <= 2 then
			var2 = 0
			helper_20c72d9f(0, 2215, 5, 0, 0)
		end
		if at <= 3 then
			helper_20c72d9f(0, 2216, 5, 0, 0)
		end
		if at <= 4 then
			var2 = 1
			helper_20c72d9f(0, 2211, 5, 0, 0)
		end
		if at <= 5 then
			var2 = 1
			active_chr_no_2 = 1
			helper_20c72d9f(0, 2212, 5, 0, 0)
		end
		var2 = 1
		return var2, arg0
	end
	helper_9ac5c278(0, 2200, 5, 0, 0)
	var1 = helper_ac82f7c0(0, 4, 4, 0)
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
			helper_20c72d9f(0, 2213, 5, 0, 0)
			if vm.skipping() then
				return skip(2)
			end
			var2 = 0
		else
			event.SysSePlay(24)
			if bit32.band(arg0, 8) ~= 0 then
				active_chr_no = event.GetActiveChrNo() or active_chr_no
				if active_chr_no == 0 or active_chr_no == 2 then
					helper_20c72d9f(0, 2215, 5, 0, 0)
					if vm.skipping() then
						return skip(3)
					end
					event.SetCharaCondition(0, 1, 0)
					event.AddHpRate2(0, -0.7)
				else
					helper_20c72d9f(0, 2216, 5, 0, 0)
					if vm.skipping() then
						return skip(4)
					end
					event.SetCharaCondition(1, 1, 0)
					event.AddHpRate2(1, -0.7)
				end
				var2 = 1
			end
			if bit32.band(arg0, 16) ~= 0 then
				helper_20c72d9f(0, 2211, 5, 0, 0)
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
				helper_20c72d9f(0, 2212, 5, 0, 0)
				if vm.skipping() then
					return skip(6)
				end
				var2 = 1
			end
		end
	end
	return var2, arg0
end

--- Helper function.
local function helper_14424()
	local stage_id: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		var1 = 0
		var1 = 110
		var1 = 111
		var1 = 112
		return var1
	end
	if vm.skipping() then
		return skip(1)
	end
	stage_id = event.DngGetStageId() or stage_id
	var1 = 0
	if stage_id == 0 or stage_id == 1 or stage_id == 6 then
		var1 = 110
	end
	if stage_id == 5 then
		var1 = 111
	end
	if stage_id == 2 or stage_id == 4 or stage_id == 3 then
		var1 = 112
	end
	return var1
end

--- Helper function.
local function helper_14720(arg0: any)
	local var1: s32 = 0
	local var2: f32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var1 = 0
			var2 = 0.0
			var2 = vm.f32(var2 + vm.f32(0.01))
			var1 = var1 + 1
		end
		if at <= 2 then
			var4 = helper_14424()
			var1 = 0
			var2 = vm.f32(var2 - vm.f32(0.004))
			var1 = var1 + 1
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var1 = 0
	var2 = 0.0
	while var1 <= 5 do
		event.SetTbAngle(var2)
		var2 = vm.f32(var2 + vm.f32(0.01))
		var1 = var1 + 1
		if vm.wait() then
			return skip(2)
		end
	end
	var4 = helper_14424()
	var3 = event.GetSndId(3) or var3
	event.SndSePlay(var3, var4)
	var1 = 0
	while var1 <= 4 do
		event.SetTbAngle(var2)
		var2 = vm.f32(var2 - vm.f32(0.004))
		var1 = var1 + 1
		if vm.wait() then
			return skip(3)
		end
	end
end

--- Helper function.
local function helper_14ac4(arg0: f32)
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var1 = 0
			arg0 = vm.f32(0.04)
			arg0 = vm.f32(arg0 + vm.f32(0.13))
			var1 = var1 + 1
		end
		return arg0
	end
	if vm.skipping() then
		return skip(1)
	end
	var1 = 0
	arg0 = vm.f32(0.04)
	while var1 <= 10 do
		event.SetTbAngle(arg0)
		arg0 = vm.f32(arg0 + vm.f32(0.13))
		var1 = var1 + 1
		if vm.wait() then
			return skip(2)
		end
	end
	return arg0
end

--- Helper function.
local function helper_14090(arg0: s32, arg1: s32, arg2: f32)
	local category: s32 = 0
	local var4: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		var4 = vm.f32(var4 / 2.0)
		var4 = vm.f32(var4 / 2.0)
		var4 = vm.f32(var4 / 2.0)
		arg2 = var4
		return arg2
	end
	if vm.skipping() then
		return skip(1)
	end
	category = event.GetItemType(arg1) or category
	var4 = event.GetAdjustPolygonScale(arg0, 6.0) or var4
	if category == 0 then
		var4 = vm.f32(var4 / 2.0)
	end
	if category == 2 then
		var4 = vm.f32(var4 / 2.0)
	end
	if category == 4 then
		var4 = vm.f32(var4 / 2.0)
	end
	arg2 = var4
	return arg2
end

--- Helper function.
local function helper_14cc4(arg0: f32)
	local var1: s32 = 0
	local var2: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var1 = 0
			arg0 = vm.f32(arg0 + vm.f32(0.18))
			var1 = var1 + 1
		end
		if at <= 2 then
			var1 = 0
			var2 = vm.f32(0.06)
			arg0 = vm.f32(arg0 - var2)
			var2 = vm.f32(var2 - vm.f32(0.008))
			var1 = var1 + 1
		end
		if at <= 3 then
			var1 = 0
			var2 = vm.f32(0.005)
			arg0 = vm.f32(arg0 + var2)
			var2 = vm.f32(var2 + vm.f32(0.01))
			var1 = var1 + 1
		end
		if at <= 4 then
			var1 = 0
			var2 = vm.f32(0.03)
			arg0 = vm.f32(arg0 - var2)
			var2 = vm.f32(var2 - vm.f32(0.005))
			var1 = var1 + 1
		end
		if at <= 5 then
			var1 = 0
			var2 = vm.f32(0.01)
			arg0 = vm.f32(arg0 + var2)
			var2 = vm.f32(var2 + vm.f32(0.01))
			var1 = var1 + 1
		end
		return arg0
	end
	if vm.skipping() then
		return skip(1)
	end
	var1 = 0
	while var1 < 10 do
		event.SetTbAngle(arg0)
		arg0 = vm.f32(arg0 + vm.f32(0.18))
		var1 = var1 + 1
		if vm.wait() then
			return skip(2)
		end
	end
	var1 = 0
	var2 = vm.f32(0.06)
	while var1 <= 6 do
		event.SetTbAngle(arg0)
		arg0 = vm.f32(arg0 - var2)
		var2 = vm.f32(var2 - vm.f32(0.008))
		var1 = var1 + 1
		if vm.wait() then
			return skip(3)
		end
	end
	var1 = 0
	var2 = vm.f32(0.005)
	while var1 <= 8 do
		event.SetTbAngle(arg0)
		arg0 = vm.f32(arg0 + var2)
		var2 = vm.f32(var2 + vm.f32(0.01))
		var1 = var1 + 1
		if vm.wait() then
			return skip(4)
		end
	end
	var1 = 0
	var2 = vm.f32(0.03)
	while var1 <= 6 do
		event.SetTbAngle(arg0)
		arg0 = vm.f32(arg0 - var2)
		var2 = vm.f32(var2 - vm.f32(0.005))
		var1 = var1 + 1
		if vm.wait() then
			return skip(5)
		end
	end
	var1 = 0
	var2 = vm.f32(0.01)
	while var1 <= 4 do
		event.SetTbAngle(arg0)
		arg0 = vm.f32(arg0 + var2)
		var2 = vm.f32(var2 + vm.f32(0.01))
		var1 = var1 + 1
		if vm.wait() then
			return skip(6)
		end
	end
	return arg0
end

--- Helper function.
local function helper_15608(arg0: s32, arg1: s32)
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local argc: s32 = 0
	local argc_2: s32 = 0
	local count_2: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local var14: s32 = 0
	local stage_id: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_cc3c3399(15)
		end
		if at <= 3 then
			helper_14720(0)
		end
		if at <= 4 then
			helper_cc3c3399(5)
		end
		if at <= 5 then
			helper_093c85e9()
		end
		if at <= 6 then
			helper_cc3c3399(5)
		end
		if at <= 7 then
			var6 = helper_14ac4(var6)
		end
		if at <= 8 then
			var7 = helper_14090(13, arg0, var7)
			var6 = helper_14cc4(var6)
		end
		if at <= 9 then
			helper_1388d2a9()
		end
		if at <= 10 then
			argc = 0
			argc_2 = 0
			helper_e350e692(arg0, count_2)
		end
		if at <= 11 then
			helper_20c72d9f(0, -1, 8, 0, 0)
		end
		if at <= 12 then
			print("CHECK_GET_ITEM_LIMIT = ", argc, "\n")
			print("CHECK_ITEM_OVER      = ", argc_2, "\n")
			helper_cc3c3399(10)
		end
		if at <= 14 then
			helper_20c72d9f(0, 2240, 8, 0, 0)
		end
		if at <= 15 then
			helper_20c72d9f(0, 2250, 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.DngPause(535, 1)
	event.AssignStack(5)
	event.ClearStack(5)
	do
		local out1, out2, out3, out4 = event.GetDunWorldCoord(1)
		var2 = out1 or var2
		var3 = out2 or var3
		var4 = out3 or var4
		var5 = out4 or var5
	end
	event.SetWorldCoord(var2, var3, var4, var5)
	if vm.wait() then
		return skip(2)
	end
	if arg0 >= 0 then
		event.SetLoadbgFile(arg0, 1, "effect/itemget.gltf")
	else
		event.SetLoadbgFile("effect/itemget.gltf")
	end
	event.SetTbAngle(0.0)
	event.SetTbStatus(2)
	event.CmrsInit()
	event.CmrsSetPos(0.0, 29.0, 57.0)
	event.CmrsSetRef(0.0, 10.0, 0.0)
	event.CmrsMove(0.0, 22.27, 41.0, 0.0, 14.27, 0.0, 80)
	helper_cc3c3399(15)
	if vm.skipping() then
		return skip(3)
	end
	helper_14720(0)
	if vm.skipping() then
		return skip(4)
	end
	helper_cc3c3399(5)
	if vm.skipping() then
		return skip(5)
	end
	helper_093c85e9()
	if vm.skipping() then
		return skip(6)
	end
	event.LoadChara(5, "effect/itemget.gltf", "info", 12)
	event.CharaActive(12)
	event.EohSyncChara(1, 12)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, 0.0, 0.0, 0.0)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(1, "ゲット", 6)
	helper_cc3c3399(5)
	if vm.skipping() then
		return skip(7)
	end
	var6 = helper_14ac4(var6)
	if vm.skipping() then
		return skip(8)
	end
	if arg0 >= 0 then
		event.LoadItem(5, arg0, "info", 13, 1)
		event.CharaActive(1, 13)
		event.EohSyncChara(0, 13)
		var7 = helper_14090(13, arg0, var7)
		event.EohSetScale(0, var7, var7, var7)
		event.SetCharaShow(13, 1, 1, 0.1)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsSetPos(0, 0.0, -2.5, 0.0)
		event.ObjsSetRot(0, 0.0, 0.0, 0.0)
		event.ObjsPosDelay(0, 4)
		event.ObjsJump(0, 0.0, 17.0, 0.0, -0.3, 20)
		event.ObjsJump(0, 0.0, 17.0, 0.0, -0.4, 8)
		event.ObjsJump(0, 0.0, 17.0, 0.0, -0.2, 5)
	end
	var6 = helper_14cc4(var6)
	if vm.skipping() then
		return skip(9)
	end
	helper_1388d2a9()
	if vm.skipping() then
		return skip(10)
	end
	if arg0 >= 0 then
		argc = 0
		argc_2 = 0
		count_2 = event.CheckGetItemLimit(arg0, arg1) or count_2
		if count_2 >= 1 then
			event.AddItem(arg0, count_2)
			helper_e350e692(arg0, count_2)
			if vm.skipping() then
				return skip(11)
			end
		else
			event.SetMesWindowMode(0, 4)
			event.SetMesDrawspeed(0, 1)
			event.SetMesItem(0, 1, arg0)
			event.MesMake_2(0, "[アイテム１] gefunden,\naber du hast keinen Platz daf[UNI00fc]r.")
			helper_20c72d9f(0, -1, 8, 0, 0)
			if vm.skipping() then
				return skip(12)
			end
			event.SetMesDrawspeed(0, 0)
		end
		argc = event.CheckGetItemLimit() or argc
		argc_2 = event.CheckItemOver() or argc_2
		print("CHECK_GET_ITEM_LIMIT = ", argc, "\n")
		print("CHECK_ITEM_OVER      = ", argc_2, "\n")
		if argc_2 >= 1 then
			event.SetFadeOut(10)
			helper_cc3c3399(10)
			if vm.skipping() then
				return skip(13)
			end
			event.GotoMenu(17)
			if vm.wait() then
				return skip(14)
			end
		end
	else
		event.SetMesWindowMode(0, 4)
		event.SetMesDrawspeed(0, 1)
		helper_20c72d9f(0, 2240, 8, 0, 0)
		if vm.skipping() then
			return skip(15)
		end
		event.SetMesDrawspeed(0, 0)
	end
	event.CharaActive(1, 0)
	event.DeleteChara(12)
	event.DeleteChara(13)
	event.SetTbAngle(1.0)
	event.SetCrossfade(10)
	event.SetWorldCoord(0.0, 0.0, 0.0, 0.0)
	do
		local out1, out2, out3 = event.GetBeforeCameraNextPos()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	event.SetCameraPos(position_x, position_y, position_z)
	do
		local out1, out2, out3 = event.GetBeforeCameraNextRef()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	event.SetCameraRef(position_x, position_y, position_z)
	event.ResetCamera(0)
	var14 = event.GetTrialVersion() or var14
	stage_id = event.DngGetStageId() or stage_id
	if arg0 == 306 and (stage_id == 0 or var14 == 1) then
		event.SetMesWindowMode(0, 4)
		helper_20c72d9f(0, 2250, 8, 0, 0)
		if vm.skipping() then
			return skip(16)
		end
	end
	event.DngPause(535, 0)
	event.Finish()
end

--- Helper function.
local function helper_14320(arg0: s32, arg1: any, arg2: f32)
	local var4: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		arg2 = var4
		return arg2
	end
	if vm.skipping() then
		return skip(1)
	end
	event.GetItemType(arg1)
	var4 = event.GetAdjustPolygonScale(arg0, 4.0) or var4
	arg2 = var4
	return arg2
end

--- Helper function.
local function helper_16b44(arg0: s32, arg1: s32, arg2: any, arg3: any)
	local var4: s32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: s32 = 0
	local var10: f32 = 0
	local var11: any = 0
	local value: s32 = 0
	local var14: any = 0
	local var15: f32 = 0
	local var17: any = 0
	local argc: s32 = 0
	local count_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_cc3c3399(15)
		end
		if at <= 3 then
			helper_14720(0)
		end
		if at <= 4 then
			helper_cc3c3399(5)
		end
		if at <= 5 then
			helper_093c85e9()
		end
		if at <= 6 then
			var10 = helper_14ac4(var10)
		end
		if at <= 7 then
			var10 = helper_14cc4(var10)
		end
		if at <= 8 then
			helper_cc3c3399(10)
		end
		if at <= 9 then
			helper_cc3c3399(8)
		end
		if at <= 10 then
			helper_cc3c3399(10)
		end
		if at <= 11 then
			helper_20c72d9f(0, 2230, 8, 256, 208)
		end
		if at <= 12 then
			helper_20c72d9f(0, 2231, 8, 256, 208)
		end
		if at <= 13 then
			local _ = helper_9ac5c278(0, 2232, 8, 0, 0)
			var11 = helper_ac82f7c0(0, 2, 0, 1)
		end
		if at <= 14 then
			var14 = arg0
			arg0 = arg2
			arg2 = var14
			var14 = arg1
			arg1 = arg3
			arg3 = var14
			var15 = helper_14320(16, arg0, var15)
			var15 = helper_14320(17, arg2, var15)
			helper_cc3c3399(10)
		end
		if at <= 15 then
			helper_cc3c3399(60)
		end
		if at <= 16 then
			helper_cc3c3399(6)
		end
		if at <= 17 then
			helper_4457cf9b(1)
		end
		if at <= 18 then
			helper_e350e692(arg2, count_2)
		end
		if at <= 19 then
			helper_20c72d9f(0, -1, 8, 0, 0)
		end
		if at <= 20 then
			var17 = arg2
			helper_e350e692(arg0, count_2)
		end
		if at <= 21 then
			helper_20c72d9f(0, -1, 8, 0, 0)
		end
		if at <= 22 then
			var17 = arg0
			helper_cc3c3399(10)
		end
		var9 = 0
		var9 = var9 + 1
	end
	if vm.skipping() then
		return skip(1)
	end
	event.DngPause(529, 1)
	var4 = event.SndLoadSound(8, "snd2/sp/sp_010.sound.json") or var4
	event.AssignStack(5)
	event.ClearStack(5)
	event.SetLoadbgFile(
		arg0,
		1,
		arg2,
		1,
		"event/tbox/p00_27a_ex.gltf",
		"event/tbox/l_box.gltf",
		"event/tbox/r_box.gltf",
		"event/tbox/p00_41a.gltf",
		"event/tbox/p00_27a_ex_l.gltf",
		"event/tbox/p00_27a_ex_r.gltf"
	)
	do
		local out1, out2, out3, out4 = event.GetDunWorldCoord(1)
		var5 = out1 or var5
		var6 = out2 or var6
		var7 = out3 or var7
		var8 = out4 or var8
	end
	event.SetWorldCoord(var5, var6, var7, var8)
	if vm.wait() then
		return skip(2)
	end
	event.SetTbAngle(0.0)
	event.SetTbStatus(2)
	event.CmrsInit()
	event.CmrsSetPos(0.0, 29.0, 57.0)
	event.CmrsSetRef(0.0, 10.0, 0.0)
	event.CmrsMove(0.0, 22.27, 41.0, 0.0, 14.27, 0.0, 80)
	helper_cc3c3399(15)
	if vm.skipping() then
		return skip(3)
	end
	helper_14720(0)
	if vm.skipping() then
		return skip(4)
	end
	helper_cc3c3399(5)
	if vm.skipping() then
		return skip(5)
	end
	helper_093c85e9()
	if vm.skipping() then
		return skip(6)
	end
	event.LoadChara(5, "event/tbox/p00_27a_ex.gltf", "info", 12)
	event.CharaActive(0, 12)
	event.EohSyncChara(0, 12)
	event.EohSetPos(0, 0.0, 0.0, 0.0)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSetMotion(0, "宝箱ピエロ出現", 5)
	event.LoadChara(5, "event/tbox/p00_41a.gltf", "info", 13)
	event.CharaActive(0, 13)
	event.EohSyncChara(1, 13)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, 0.0, 0.0, 0.0)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(1, "出現", 5)
	var10 = helper_14ac4(var10)
	if vm.skipping() then
		return skip(7)
	end
	event.SndSePlay(var4, 0)
	event.SndSePlay(var4, 1)
	event.CharaActive(12)
	event.EohSetMotion(0, "宝箱ピエロ出現", 6)
	event.CharaActive(13)
	event.ObjsSetMotion(1, "出現", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.CmrsInit()
	event.CmrsPrdelay(4)
	event.CmrsMove2(0.14, 22.84, 83.75, 0.0, 60.0, 0.0, 16, 2, 1.0)
	event.CmrsMove2(0.21, 18.87, 93.0, 0.0, 36.0, 0.0, 20, 0, 1.0)
	var10 = helper_14cc4(var10)
	if vm.skipping() then
		return skip(8)
	end
	helper_cc3c3399(10)
	if vm.skipping() then
		return skip(9)
	end
	event.CharaActive(0, 12)
	event.LoadChara(5, "event/tbox/p00_27a_ex_r.gltf", "info", 14)
	event.CharaActive(14)
	event.SetCharaPos(14, 0.0, 0.0, 0.0)
	event.SetCharaRot(14, 0.0, 0.0, 0.0)
	event.SetMotion(14, "宝箱発生（右手）", 6)
	event.SetReference(13, "s_pre", 14)
	event.LoadChara(5, "event/tbox/p00_27a_ex_l.gltf", "info", 15)
	event.CharaActive(15)
	event.SetCharaPos(15, 0.0, 0.0, 0.0)
	event.SetCharaRot(15, 0.0, 0.0, 0.0)
	event.SetMotion(15, "宝箱出現（左手）", 6)
	event.SetReference(13, "b_pre", 15)
	event.LoadChara(5, "event/tbox/r_box.gltf", "info", 18)
	event.CharaActive(18)
	event.SetCharaPos(18, 0.0, 0.0, 0.0)
	event.SetCharaRot(18, 0.0, 0.0, 0.0)
	event.SetReference(13, "s_pre", 18)
	event.SetCharaType(18, 4)
	event.LoadChara(5, "event/tbox/l_box.gltf", "info", 19)
	event.CharaActive(19)
	event.SetCharaPos(19, 0.0, 0.0, 0.0)
	event.SetCharaRot(19, 0.0, 0.0, 0.0)
	event.SetReference(13, "b_pre", 19)
	event.SetCharaType(19, 4)
	event.SndSePlay(var4, 2)
	event.SetCharaShow(18, 0)
	event.SetCharaShow(19, 0)
	helper_cc3c3399(8)
	if vm.skipping() then
		return skip(10)
	end
	event.SetCharaShow(18, 1, 1, 0.08)
	event.SetCharaShow(19, 1, 1, 0.08)
	helper_cc3c3399(10)
	if vm.skipping() then
		return skip(11)
	end
	event.CharaActive(0, 14)
	event.CharaActive(0, 15)
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	helper_20c72d9f(0, 2230, 8, 256, 208)
	if vm.skipping() then
		return skip(12)
	end
	helper_20c72d9f(0, 2231, 8, 256, 208)
	if vm.skipping() then
		return skip(13)
	end
	event.SetMesShippo(0, 0)
	event.SetMesQuestionGyou(0, 0)
	event.SndSePlay(var4, 3)
	local _ = helper_9ac5c278(0, 2232, 8, 0, 0)
	var11 = helper_ac82f7c0(0, 2, 0, 1)
	if vm.skipping() then
		return skip(14)
	end
	event.SetMesPos(0, 0)
	value = event.GetRandInt(100) or value
	if vm.imod(value, 2) == 0 then
		var14 = arg0
		arg0 = arg2
		arg2 = var14
		var14 = arg1
		arg1 = arg3
		arg3 = var14
	end
	event.LoadItem(5, arg0, "info", 16, 1)
	event.CharaActive(0, 16)
	event.SetCharaPos(16, 0.0, 0.0, 0.0)
	event.SetCharaRot(16, 0.0, 0.0, 0.0)
	event.EohSyncChara(6, 16)
	var15 = helper_14320(16, arg0, var15)
	event.EohSetScale(6, var15, var15, var15)
	event.LoadItem(5, arg2, "info", 17, 1)
	event.CharaActive(0, 17)
	event.SetCharaPos(17, 0.0, 0.0, 0.0)
	event.SetCharaRot(17, 0.0, 0.0, 0.0)
	event.EohSyncChara(6, 17)
	var15 = helper_14320(17, arg2, var15)
	event.EohSetScale(6, var15, var15, var15)
	event.CharaActive(1, 16)
	event.SetReference(13, "s_pre", 16)
	event.CharaActive(1, 17)
	event.SetReference(13, "b_pre", 17)
	event.ObjsSetMotion(1, "中身公開", 2)
	if var11 == 0 then
		event.ObjsNextMotion(1, "大きい宝箱", 2)
		event.ObjsNextMotion(1, "大きい宝箱L", 4)
	else
		event.ObjsNextMotion(1, "小さい宝箱", 2)
		event.ObjsNextMotion(1, "小さい宝箱L", 4)
	end
	helper_cc3c3399(10)
	if vm.skipping() then
		return skip(15)
	end
	event.SetCharaShow(18, 0, 1, 0.04)
	event.SetCharaShow(19, 0, 1, 0.04)
	event.SndSePlay(var4, 4)
	event.SndSePlay(var4, 5)
	helper_cc3c3399(60)
	if vm.skipping() then
		return skip(16)
	end
	event.SndSePlay(var4, 7)
	helper_cc3c3399(6)
	if vm.skipping() then
		return skip(17)
	end
	event.SndSePlay(var4, 6)
	helper_4457cf9b(1)
	if vm.skipping() then
		return skip(18)
	end
	if var11 == 0 then
		count_2 = event.CheckGetItemLimit(arg2, arg3) or count_2
		if count_2 >= 1 then
			helper_e350e692(arg2, count_2)
			if vm.skipping() then
				return skip(19)
			end
		else
			event.SetMesWindowMode(0, 4)
			event.SetMesDrawspeed(0, 1)
			event.SetMesItem(0, 1, arg2)
			event.MesMake_2(0, "[アイテム１] erhalten,\naber du hast keinen Platz daf[UNI00fc]r.")
			helper_20c72d9f(0, -1, 8, 0, 0)
			if vm.skipping() then
				return skip(20)
			end
		end
		var17 = arg2
	else
		count_2 = event.CheckGetItemLimit(arg0, arg1) or count_2
		if count_2 >= 1 then
			helper_e350e692(arg0, count_2)
			if vm.skipping() then
				return skip(21)
			end
		else
			event.SetMesWindowMode(0, 4)
			event.SetMesDrawspeed(0, 1)
			event.SetMesItem(0, 1, arg0)
			event.MesMake_2(0, "[アイテム１] erhalten,\naber du hast keinen Platz daf[UNI00fc]r.")
			helper_20c72d9f(0, -1, 8, 0, 0)
			if vm.skipping() then
				return skip(22)
			end
		end
		var17 = arg0
	end
	event.SetMesDrawspeed(0, 0)
	event.AddItem(var17, count_2)
	argc = event.CheckItemOver() or argc
	if argc >= 1 then
		event.SetFadeOut(10)
		helper_cc3c3399(10)
		if vm.skipping() then
			return skip(23)
		end
		event.GotoMenu(17)
		if vm.wait() then
			return skip(24)
		end
	end
	event.CharaActive(0)
	event.DngPause(529, 0)
	var9 = 0
	while var9 <= 7 do
		event.DeleteChara(12 + var9)
		var9 = var9 + 1
	end
	event.SetTbAngle(1.0)
	event.SetCrossfade(10)
	event.Finish()
end

--- Helper function.
local function helper_1b858()
	local flags: s32 = 0
	local item_x: s32 = 0
	local item_y: s32 = 0
	local num_x: s32 = 0
	local num_y: s32 = 0
	local now_party_chara_id: s32 = 0
	local var6: any = 0
	local var8: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_9ac5c278(0, -1, 5, 0, 0)
				var6 = helper_ac82f7c0(0, 2, 2, 0)
			end
			return 0
		end
		if at <= 3 then
			return 0
		end
		if at <= 4 then
			return 0
		end
		if at <= 5 then
			return 0
		end
		if at <= 6 then
			var8 = 1
			helper_16b44(item_x, num_x, item_y, num_y)
		end
		if at <= 7 then
			var8 = 1
			helper_15608(item_x, num_x)
		end
		var8 = 1
		return item_x
	end
	event.Initialize()
	do
		local out1, out2, out3, out4, out5 = event.GetTboxParam()
		flags = out1 or flags
		item_x = out2 or item_x
		item_y = out3 or item_y
		num_x = out4 or num_x
		num_y = out5 or num_y
	end
	print("-----------------------------------------------------------------------------------------\n")
	print("tbox type = ", flags, "\n")
	print("item1 = ", item_x, ", ", num_x, "\n")
	print("item2 = ", item_y, ", ", num_y, "\n")
	print("-----------------------------------------------------------------------------------------\n")
	if bit32.band(flags, 256) ~= 0 then
		now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
		if now_party_chara_id == 9 then
			event.DngPause(513, 1)
			helper_d163dbd7()
			event.SetMesWindowMode(0, 1)
			event.SetMesShippo(0, 0)
			event.MesMake_2(0, "Was? Moment! Ich rieche etwas!\n      Vorsicht!\nIch glaub, es ist ein Mime.")
			helper_20c72d9f(0, -1, 5, 0, 0)
			if vm.skipping() then
				return skip(1)
			end
			event.SetMesQuestionGyou(0, 1)
			event.SetMesShippo(0, 0)
			event.SetMesEtc(0, 0, 1)
			event.SetMesEtc(0, 1, 1)
			event.MesMake_2(0, "Immer noch [UNI00f6]ffnen?\nJa.\nNein.")
			helper_9ac5c278(0, -1, 5, 0, 0)
			var6 = helper_ac82f7c0(0, 2, 2, 0)
			if vm.skipping() then
				return skip(2)
			end
			event.SetMesQuestionGyou(0, 0)
			event.SetMesShippo(0, 1)
			event.SetMesEtc(0, 0, 0)
			event.SetMesEtc(0, 1, 0)
			event.DngPause(513, 0)
			if var6 == 1 then
			else
				return 0
			end
		end
		helper_1b204(item_x, num_x)
		if vm.skipping() then
			return skip(3)
		end
		return 0
	end
	event.DngPause(513, 1)
	helper_d163dbd7()
	event.SetMesWindowMode(0, 1)
	event.SetMesQuestionGyou(0, 1)
	event.SetMesShippo(0, 0)
	event.SetMesEtc(0, 0, 1)
	event.SetMesEtc(0, 1, 1)
	if bit32.band(flags, 2) ~= 0 then
		local t0: s32
		t0, flags = helper_1952c(flags)
		local t1 = t0
		if vm.skipping() then
			return skip(4)
		end
		if t1 ~= 0 then
			event.DngPause(513, 0)
			event.Finish()
			return 0
		end
	end
	if bit32.band(flags, 4) ~= 0 then
		local t2: s32
		t2, flags = helper_1a3c4(flags)
		local t3 = t2
		if vm.skipping() then
			return skip(5)
		end
		if t3 ~= 0 then
			event.DngPause(513, 0)
			event.Finish()
			return 0
		end
	end
	event.SetMesQuestionGyou(0, 0)
	event.SetMesShippo(0, 1)
	event.SetMesEtc(0, 0, 0)
	event.SetMesEtc(0, 1, 0)
	event.DngPause(513, 0)
	event.SetCrossfade(30)
	event.SetStatusbarShow(0, 0.16666667)
	event.CharaActive(0, 0)
	var8 = 0
	if bit32.band(flags, 512) ~= 0 then
		helper_15608(-1, -1)
		if vm.skipping() then
			return skip(6)
		end
		var8 = 1
	end
	if bit32.band(flags, 128) ~= 0 then
		helper_16b44(item_x, num_x, item_y, num_y)
		if vm.skipping() then
			return skip(7)
		end
		var8 = 1
	end
	if var8 == 0 then
		helper_15608(item_x, num_x)
		if vm.skipping() then
			return skip(8)
		end
		var8 = 1
	end
	event.SetStatusbarShow(1, 0.16666667)
	return item_x
end

--- Helper function.
local function helper_cd88()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_9fa762c4(1, 7)
		helper_9ac5c278(1, -1, 15, 0, 0)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_9fa762c4(1, 7)
	event.SetMesPreset(1, 2)
	event.MesMake_2(1, "Anhalten mit (O).")
	helper_9ac5c278(1, -1, 15, 0, 0)
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script[99] = program_99

--- Program 100.
script[100] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_28f0c()
			if not vm.skipping() then
				return landing1()
			end
		end
		var0 = vm.i32(bit32.bor(var0, 8))
		helper_2a734()
		helper_bf9857b2(vm.f32(5.2), 0.0, -790.0, 0.0)
	end
	function part2()
		helper_bf9857b2(vm.f32(5.2), 0.0, -790.0, 0.0)
		event.SetCameraRef(5.2, 30.0, -790.0)
		event.SetCameraPos(5.2, 40.0, -910.0)
		event.ResetCamera(0)
		event.SetFadeIn(30)
		event.Finish()
	end
	function landing1()
		var0 = event.GetCnt(20) or var0
		var0 = vm.i32(bit32.bor(var0, 8))
		event.SetCnt(20, var0)
		helper_2a734()
		return part2()
	end
	program_99()
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	if vm.wait() then
		return skip(2)
	end
	var0 = event.GetCnt(17) or var0
	if bit32.band(var0, 256) == 0 or bit32.band(var0, 512) == 0 then
		var0 = event.GetCnt(20) or var0
		if bit32.band(var0, 8) == 0 then
			helper_28f0c()
			if vm.skipping() then
				return skip(3)
			end
			var0 = event.GetCnt(20) or var0
			var0 = vm.i32(bit32.bor(var0, 8))
			event.SetCnt(20, var0)
		end
		helper_2a734()
	end
	return part2()
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a2e87194(64)
		end
	end
	if vm.wait() then
		return skip(1)
	end
	helper_a2e87194(64)
	if vm.skipping() then
		return skip(2)
	end
end

--- Program 160.
script[160] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_a2e87194(64)
		end
	end
	helper_28f0c()
	if vm.skipping() then
		return skip(1)
	end
	if vm.wait() then
		return skip(2)
	end
	helper_a2e87194(64)
	if vm.skipping() then
		return skip(3)
	end
end

--- Program 200.
script[200] = function()
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.AddItem(305, 1)
	event.AddItem(306, 1)
	argc = event.GetItemHaveNum(10) or argc
	if argc <= 0 then
		event.AddItem(10, 1)
	end
	argc = event.GetItemHaveNum(302) or argc
	if argc <= 0 then
		event.AddItem(302, 1)
	end
	event.SetFlag(220, 1)
	event.SetFlag(317, 1)
	event.DelMonster(-1)
	event.Finish()
end

--- Program 300.
script[300] = function()
	local active_chr_no: s32 = 0
	local var1: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_20c72d9f(0, 21, 5, 256, 208)
			end
			return
		end
		if at <= 3 then
			helper_cc3c3399(30)
		end
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 1)
		if active_chr_no == 2 then
			helper_20c72d9f(0, 20, 5, 256, 208)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_20c72d9f(0, 21, 5, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		end
		event.Finish()
		return
	end
	var1 = helper_18ada31e(2, -1)
	if vm.skipping() then
		return skip(3)
	end
	if var1 == 0 then
		event.DelMonster(-1)
		event.DngPause(16384, 0)
		event.SetFadeOut(30)
		helper_cc3c3399(30)
		if vm.skipping() then
			return skip(4)
		end
		event.LoadScript("d07/d07.stb", 1000)
	else
		event.Finish()
	end
end

--- Program 1100.
script[1100] = function()
	local var0: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		var1 = vm.i32(bit32.bor(var1, 256))
	end
	var0 = helper_1b858()
	if vm.skipping() then
		return skip(1)
	end
	var1 = event.GetCnt(17) or var1
	if var0 == 189 then
		if bit32.band(var1, 256) == 0 then
			var1 = event.GetCnt(17) or var1
			var1 = vm.i32(bit32.bor(var1, 256))
			event.SetCnt(17, var1)
			return
		end
	end
	if var0 == 189 then
		var1 = event.GetCnt(17) or var1
		var1 = vm.i32(bit32.bor(var1, 512))
		event.SetCnt(17, var1)
	end
end

--- Program 1120.
script[1120] = function()
	local active_chr_no: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local yaw: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local var11: s32 = 0
	local weight: f32 = 0
	local var14: f32 = 0
	local now_party_chara_id: s32 = 0
	local var17: s32 = 0
	local var18: s32 = 0
	local var19: f32 = 0
	local pos_x_3: f32 = 0
	local pos_y_3: f32 = 0
	local pos_z_3: f32 = 0
	local pos_x_4: f32 = 0
	local pos_y_4: f32 = 0
	local pos_z_4: f32 = 0
	local var26: f32 = 0
	local value: s32 = 0
	local angle: f32 = 0
	local value_2: s32 = 0
	local var30: s32 = 0
	local var31: f32 = 0
	local var32: s32 = 0
	local result: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_20c72d9f(0, 23, 8, 0, 0)
			end
			var1 = vm.f32(vm.f32(vm.sin(yaw) * 25.0) + pos_x)
			var2 = pos_y
			var3 = vm.f32(vm.f32(vm.cos(yaw) * 25.0) + pos_z)
			return
		end
		if at <= 3 then
			helper_d163dbd7()
			helper_093c85e9()
		end
		if at <= 5 then
			helper_093c85e9()
		end
		if at <= 6 then
			var14 = vm.f32(var14 - vm.f32(3.1415927))
			var18 = 0
			var19 = vm.f32(0.6)
			var14 = vm.f32(var14 + var19)
			helper_cd88()
			local _ = helper_ec9ebfb2(0)
		end
		if at <= 7 then
			var18 = var18 + 1
		end
		if at <= 8 then
			helper_5dbff6db()
			value = 0
			value = value + 4
			var18 = 0
			var14 = vm.f32(var14 + var19)
		end
		if at <= 9 then
			var19 = vm.f32(var19 * vm.f32(0.9))
			angle = var26
			local _ = helper_68fde5f8(var14, angle, vm.f32(0.08)) == 0
			var17 = 0
			angle = vm.f32(var26 - vm.f32(3.1415927))
			local _ = helper_68fde5f8(var14, angle, vm.f32(0.08)) == 0
			var17 = 1
			var18 = vm.i32(var18 + 1)
			local _ = helper_68fde5f8(var14, var26, 1.0) == 0
			var17 = 0
			var17 = 1
			var26 = var14
			helper_cc3c3399(20)
		end
		if at <= 10 then
			var30 = 100
			var30 = 6
			var30 = 0
			var30 = 2
			var30 = 100
			var30 = 4
			var26 = vm.f32(var26 + vm.f32(3.14))
			var17 = 1
			var17 = 0
			helper_cc3c3399(10)
		end
		if at <= 11 then
			var26 = vm.f32(var26 + vm.f32(3.14))
			var26 = vm.f32(var26 + vm.f32(1.57))
			var26 = vm.f32(var26 + vm.f32(1.57))
			helper_cc3c3399(20)
		end
		if at <= 12 then
			local _ = helper_68fde5f8(var14, var26, 1.0) == 0
			var17 = 0
			var17 = 1
			var31 = 1.0
			var18 = 0
			var31 = vm.f32(var31 + vm.f32(0.03))
			var18 = var18 + 1
		end
		if at <= 13 then
			helper_20c72d9f(0, 2310, 8, 0, 0)
		end
		if at <= 14 then
			helper_20c72d9f(0, 2311, 8, 0, 0)
		end
		if at <= 15 then
			helper_20c72d9f(0, 2312, 8, 0, 0)
		end
		if at <= 16 then
			helper_20c72d9f(0, 2313, 8, 0, 0)
		end
		if at <= 17 then
			helper_20c72d9f(0, 2314, 8, 0, 0)
		end
		if at <= 18 then
			var31 = vm.f32(var31 - vm.f32(0.03))
			var18 = var18 + 1
		end
		if at <= 19 then
			helper_20c72d9f(0, 2320, 8, 0, 0)
		end
		if at <= 20 then
			helper_20c72d9f(0, 2321, 8, 0, 0)
		end
		if at <= 21 then
			helper_20c72d9f(0, 2322, 8, 0, 0)
		end
		if at <= 22 then
			helper_20c72d9f(0, 2323, 8, 0, 0)
		end
		if at <= 23 then
			helper_20c72d9f(0, 2324, 8, 0, 0)
		end
		if at <= 24 then
			helper_20c72d9f(0, 2325, 8, 0, 0)
		end
		if at <= 25 then
			helper_20c72d9f(0, 2328, 8, 0, 0)
		end
		if at <= 26 then
			helper_20c72d9f(0, 2326, 8, 0, 0)
		end
		if at <= 27 then
			helper_20c72d9f(0, 2329, 8, 0, 0)
		end
		if at <= 28 then
			helper_20c72d9f(0, 2327, 8, 0, 0)
		end
		if at <= 29 then
			helper_20c72d9f(0, 2330, 8, 0, 0)
		end
	end
	event.Initialize()
	event.DngPause(513, 1)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.SetMesPreset(0, 4)
		event.SetMesWindowMode(0, 4)
		event.SetMesDrawspeed(0, 1)
		helper_d163dbd7()
		if active_chr_no == 2 then
			helper_20c72d9f(0, 22, 8, 0, 0)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_20c72d9f(0, 23, 8, 0, 0)
			if vm.skipping() then
				return skip(2)
			end
		end
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 0)
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		do
			local out1, out2, out3 = event.RandomCircleGetPos(-1)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		yaw = event.GetRefAngle(pos_x, pos_y, pos_z, var1, var2, var3) or yaw
		var1 = vm.f32(vm.f32(vm.sin(yaw) * 25.0) + pos_x)
		var2 = pos_y
		var3 = vm.f32(vm.f32(vm.cos(yaw) * 25.0) + pos_z)
		event.SetCharaPos(0, var1, var2, var3)
		event.DngPause(513, 0)
		event.Finish()
		return
	end
	event.SetLoadbgFile("snd2/sp/sp_011.sound.json")
	if vm.wait() then
		return skip(3)
	end
	helper_d163dbd7()
	do
		local out1, out2, out3 = event.RandomCircleGetPos(-1)
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	event.SetCameraCtrl(0)
	event.SetFcameraFollowFlag(1)
	event.SetFcameraFollowA(pos_x_2, pos_y_2 + 30.0, pos_z_2)
	event.SetCameraSpeed(8.0)
	event.SetFcameraFollowOfs(0.0, 0.0, 0.0)
	event.SetFcameraHeight(0.0)
	event.SetFcameraDist(80.0)
	event.AssignStack(5)
	event.ClearStack(5)
	helper_093c85e9()
	if vm.skipping() then
		return skip(4)
	end
	var11 = event.SndLoadSound(8, "snd2/sp/sp_011.sound.json") or var11
	event.ChangeDir("event/dng/")
	event.SetLoadbgFile("ring.gltf", "randomcoin.gltf")
	if vm.wait() then
		return skip(5)
	end
	helper_093c85e9()
	if vm.skipping() then
		return skip(6)
	end
	weight = event.GetRndcMotNowt() or weight
	event.RandomCircleOff(-1)
	event.LoadChara(5, "ring.gltf", "info", 12)
	event.CharaActive(1, 12)
	event.SetCharaPos(12, pos_x_2, pos_y_2, pos_z_2)
	event.SetMotion(12, "ループ", 6)
	event.CharaNormalDrive(12)
	event.SetCharaMotNowt(12, weight)
	event.EohSyncChara(4, 12)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ObjsNextMotion(4, "消滅", 6)
	event.LoadChara(5, "randomcoin.gltf", "info", 13)
	event.CharaActive(1, 13)
	event.SetCharaPos(13, pos_x_2, pos_y_2 - 30.0, pos_z_2)
	var14 = event.GetRand(6.2831855) or var14
	var14 = vm.f32(var14 - vm.f32(3.1415927))
	var14 = event.AngleLimit(var14) or var14
	event.SetCharaRot(13, 0.0, var14, 0.0)
	event.ChangeDir("")
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	event.EohSyncChara(5, 13)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.ObjsSetScale(5, 0.0, 0.0, 0.0)
	event.ObjsSetScale(5, 1.0, 1.0, 1.0, 40)
	event.ObjsMove2(5, pos_x_2, pos_y_2 + 40.0, pos_z_2, 30, 2, 0.5)
	var18 = 0
	var19 = vm.f32(0.6)
	while true do
		do
			local _, out2, _ = event.GetCharaRot(13)
			var14 = out2 or var14
		end
		var14 = vm.f32(var14 + var19)
		var14 = event.AngleLimit(var14) or var14
		event.SetCharaRot(13, 0.0, var14, 0.0)
		if var18 == 10 then
			event.SndSePlay(var11, 0)
		end
		if var18 == 30 then
			helper_cd88()
		end
		if (if var18 >= 30 then helper_ec9ebfb2(0) else 0) ~= 0 or var18 > 300 then
			event.SndSeStop(var11, 0)
			event.SndSePlay(var11, 3)
			if vm.wait() then
				return skip(7)
			end
			break
		else
			var18 = var18 + 1
			if vm.wait() then
				return skip(8)
			end
		end
	end
	helper_5dbff6db()
	event.EohSyncChara(5, 13)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	do
		local out1, out2, out3 = event.GetCameraPos()
		pos_x_3 = out1 or pos_x_3
		pos_y_3 = out2 or pos_y_3
		pos_z_3 = out3 or pos_z_3
	end
	do
		local out1, out2, out3 = event.GetCameraRef()
		pos_x_4 = out1 or pos_x_4
		pos_y_4 = out2 or pos_y_4
		pos_z_4 = out3 or pos_z_4
	end
	var26 = event.GetRefAngle(pos_x_4, pos_y_4, pos_z_4, pos_x_3, pos_y_3, pos_z_3) or var26
	value = 0
	value = event.GetRandInt(10) or value
	value = vm.i32(value + 4)
	var18 = 0
	while true do
		do
			local _, out2, _ = event.GetCharaRot(13)
			var14 = out2 or var14
		end
		var14 = vm.f32(var14 + var19)
		var14 = event.AngleLimit(var14) or var14
		event.SetCharaRot(13, 0.0, var14, 0.0)
		if vm.wait() then
			return skip(9)
		end
		if var18 >= value then
			if var19 > vm.f32(0.08) then
				var19 = vm.f32(var19 * vm.f32(0.9))
			end
			angle = var26
			angle = event.AngleLimit(angle) or angle
			if var14 < angle and helper_68fde5f8(var14, angle, vm.f32(0.08)) == 0 then
				event.SetCharaRot(13, 0.0, angle, 0.0)
				var17 = 0
				break
			end
			angle = vm.f32(var26 - vm.f32(3.1415927))
			angle = event.AngleLimit(angle) or angle
			if var14 < angle and helper_68fde5f8(var14, angle, vm.f32(0.08)) == 0 then
				event.SetCharaRot(13, 0.0, angle, 0.0)
				var17 = 1
				break
			end
		end
		var18 = vm.i32(var18 + 1)
	end
	var26 = event.GetRefAngle(pos_x_4, pos_y_4, pos_z_4, pos_x_3, pos_y_3, pos_z_3) or var26
	do
		local _, out2, _ = event.GetCharaRot(13)
		var14 = out2 or var14
	end
	if helper_68fde5f8(var14, var26, 1.0) == 0 then
		var17 = 0
	else
		var17 = 1
	end
	var26 = var14
	helper_cc3c3399(20)
	if vm.skipping() then
		return skip(10)
	end
	value_2 = event.GetRandInt(10) or value_2
	if now_party_chara_id == 24 then
		var30 = 100
	else
		var30 = 6
	end
	if value_2 < var30 then
		value_2 = event.GetRandInt(10) or value_2
		if var17 == 0 then
			if now_party_chara_id == 24 then
				var30 = 0
			else
				var30 = 2
			end
		elseif now_party_chara_id == 24 then
			var30 = 100
		else
			var30 = 4
		end
		if value_2 < var30 then
			var26 = vm.f32(var26 + vm.f32(3.14))
			var26 = event.AngleLimit(var26) or var26
			event.ObjsRotation(5, 0.0, var26, 0.0, 8)
			if var17 == 0 then
				var17 = 1
			else
				var17 = 0
			end
			helper_cc3c3399(10)
			if vm.skipping() then
				return skip(11)
			end
		else
			value_2 = event.GetRandInt(10) or value_2
			if value_2 < 1 then
				var26 = vm.f32(var26 + vm.f32(3.14))
				var26 = event.AngleLimit(var26) or var26
				event.ObjsRotation(5, 0.0, var26, 0.0, 6)
				var26 = vm.f32(var26 + vm.f32(1.57))
				var26 = event.AngleLimit(var26) or var26
				event.ObjsRotation(5, 0.0, var26, 0.0, 3)
				var26 = vm.f32(var26 + vm.f32(1.57))
				var26 = event.AngleLimit(var26) or var26
				event.ObjsRotation(5, 0.0, var26, 0.0, 3)
				helper_cc3c3399(20)
				if vm.skipping() then
					return skip(12)
				end
			end
		end
	end
	var26 = event.GetRefAngle(pos_x_4, pos_y_4, pos_z_4, pos_x_3, pos_y_3, pos_z_3) or var26
	do
		local _, out2, _ = event.GetCharaRot(13)
		var14 = out2 or var14
	end
	if helper_68fde5f8(var14, var26, 1.0) == 0 then
		var17 = 0
	else
		var17 = 1
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	var31 = 1.0
	var18 = 0
	var32 = event.GetRndCircleTrapid(var17) or var32
	if var17 == 0 then
		event.SndSePlay(var11, 1)
		while var18 < 30 do
			event.BscnSetBlightRate(var31)
			var31 = vm.f32(var31 + vm.f32(0.03))
			var18 = var18 + 1
			if vm.wait() then
				return skip(13)
			end
		end
		helper_20c72d9f(0, 2310, 8, 0, 0)
		if vm.skipping() then
			return skip(14)
		end
		result = event.SetRndCircleStatus(var32) or result
		if var32 == 1 then
			helper_20c72d9f(0, 2311, 8, 0, 0)
			if vm.skipping() then
				return skip(15)
			end
		end
		if var32 == 2 then
			helper_20c72d9f(0, 2312, 8, 0, 0)
			if vm.skipping() then
				return skip(16)
			end
		end
		if var32 == 3 then
			helper_20c72d9f(0, 2313, 8, 0, 0)
			if vm.skipping() then
				return skip(17)
			end
		end
		if var32 == 4 then
			event.PostTreasureBox(pos_x_2, pos_y_2, pos_z_2, var26, 294)
			helper_20c72d9f(0, 2314, 8, 0, 0)
			if vm.skipping() then
				return skip(18)
			end
		end
	else
		event.SndSePlay(var11, 2)
		while var18 < 30 do
			event.BscnSetBlightRate(var31)
			var31 = vm.f32(var31 - vm.f32(0.03))
			var18 = var18 + 1
			if vm.wait() then
				return skip(19)
			end
		end
		helper_20c72d9f(0, 2320, 8, 0, 0)
		if vm.skipping() then
			return skip(20)
		end
		result = event.SetRndCircleStatus(var32) or result
		if var32 == 5 then
			if active_chr_no == 0 or active_chr_no == 2 then
				helper_20c72d9f(0, 2321, 8, 0, 0)
				if vm.skipping() then
					return skip(21)
				end
			end
			if active_chr_no == 1 or active_chr_no == 3 then
				helper_20c72d9f(0, 2322, 8, 0, 0)
				if vm.skipping() then
					return skip(22)
				end
			end
		end
		if var32 == 6 then
			if active_chr_no == 0 then
				helper_20c72d9f(0, 2323, 8, 0, 0)
				if vm.skipping() then
					return skip(23)
				end
			end
			if active_chr_no == 1 or active_chr_no == 3 then
				helper_20c72d9f(0, 2324, 8, 0, 0)
				if vm.skipping() then
					return skip(24)
				end
			end
			if active_chr_no == 2 then
				helper_20c72d9f(0, 2325, 8, 0, 0)
				if vm.skipping() then
					return skip(25)
				end
			end
		end
		if var32 == 8 then
			helper_20c72d9f(0, 2328, 8, 0, 0)
			if vm.skipping() then
				return skip(26)
			end
		end
		if var32 == 9 then
			helper_20c72d9f(0, 2326, 8, 0, 0)
			if vm.skipping() then
				return skip(27)
			end
		end
		if var32 == 10 then
			helper_20c72d9f(0, 2329, 8, 0, 0)
			if vm.skipping() then
				return skip(28)
			end
		end
		if var32 == 11 then
			helper_20c72d9f(0, 2327, 8, 0, 0)
			if vm.skipping() then
				return skip(29)
			end
		end
		if var32 == 12 then
			helper_20c72d9f(0, 2330, 8, 0, 0)
			if vm.skipping() then
				return skip(30)
			end
		end
	end
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	event.BscnSetBlightRate(1.0)
	if var32 == 1 then
		event.SetPullItem(pos_x_2, pos_y_2, pos_z_2, 1, 10, result / 10.0)
	end
	event.DngPause(513, 0)
	event.SetCameraCtrl(1)
	do
		local out1, out2, out3 = event.GetBeforeCameraNextPos()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	event.SetCameraPos(position_x, position_y, position_z)
	do
		local out1, out2, out3 = event.GetBeforeCameraNextRef()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	event.SetCameraRef(position_x, position_y, position_z)
	event.DeleteChara(12)
	event.DeleteChara(13)
	event.SetCrossfade(15)
	event.Finish()
end

--- Program 1130.
script[1130] = function()
	local active_chr_no: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local argc: s32 = 0
	local stage_id: s32 = 0
	local var23: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_20c72d9f(0, 23, 8, 0, 0)
			end
			return
		end
		if at <= 3 then
			helper_093c85e9()
		end
		if at <= 5 then
			helper_093c85e9()
		end
		if at <= 6 then
			pos_y_2 = vm.f32(var9 + 18.0)
			var17 = vm.f32(var17 + vm.f32(2.9))
			var17 = vm.f32(var17 + vm.f32(2.4))
			var8 = vm.f32(vm.f32(vm.sin(var17) * 14.0) + pos_x_2)
			var10 = vm.f32(vm.f32(vm.cos(var17) * 14.0) + pos_z_2)
			var17 = vm.f32(var17 - vm.f32(3.1415927))
			var18 = vm.f32(vm.f32(vm.sin(var17) * 8.0) + var8)
			var19 = vm.f32(var9 + 18.0)
			var20 = vm.f32(vm.f32(vm.cos(var17) * 8.0) + var10)
			helper_cc3c3399(16)
		end
		if at <= 7 then
			helper_cc3c3399(2)
		end
		if at <= 8 then
			helper_cc3c3399(10)
		end
		if at <= 9 then
			helper_cc3c3399(20)
		end
		if at <= 10 then
			helper_4457cf9b(0)
		end
		if at <= 11 then
			helper_20c72d9f(0, 2400, 8, 0, 0)
		end
	end
	event.Initialize()
	event.DngPause(513, 1)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.SetMesPreset(0, 4)
		event.SetMesWindowMode(0, 4)
		event.SetMesDrawspeed(0, 1)
		helper_d163dbd7()
		if active_chr_no == 2 then
			helper_20c72d9f(0, 22, 8, 0, 0)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_20c72d9f(0, 23, 8, 0, 0)
			if vm.skipping() then
				return skip(2)
			end
		end
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 0)
		event.DngPause(513, 0)
		event.Finish()
		return
	end
	event.DngPause(16, 1)
	event.AssignStack(5)
	event.ClearStack(5)
	event.SetFlag(31, 1)
	event.SetMotion(0, "立ち")
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var1 = out1 or var1
		var2 = out2 or var2
		var3 = out3 or var3
	end
	if active_chr_no == 0 then
		event.SetLoadbgFile(
			"dungeon/chara/c01_gio.gltf",
			"event/itemget_ev/itemget_ev.gltf",
			"snd2/sp/sp_012.sound.json"
		)
		if vm.wait() then
			return skip(3)
		end
		helper_093c85e9()
		if vm.skipping() then
			return skip(4)
		end
		event.LoadMotion(5, "dungeon/chara/c01_gio.gltf", "info", 0)
	end
	if active_chr_no == 1 then
		event.SetLoadbgFile(
			"dungeon/chara/c02_gio.gltf",
			"event/itemget_ev/itemget_ev.gltf",
			"snd2/sp/sp_012.sound.json"
		)
		if vm.wait() then
			return skip(5)
		end
		helper_093c85e9()
		if vm.skipping() then
			return skip(6)
		end
		event.LoadMotion(5, "dungeon/chara/c02_gio.gltf", "info", 0)
	end
	var4 = event.SndLoadSound(8, "snd2/sp/sp_012.sound.json") or var4
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	do
		local out1, out2, out3 = event.GetCameraPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	event.CopyVector(var8, var9, var10)
	event.GeostoneAnimeOff()
	event.EohSyncGeostone(1)
	do
		local out1, out2, out3 = event.EohGetPos(1)
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	pos_y_2 = vm.f32(var9 + 18.0)
	event.EohSetPos(1, pos_x_2, pos_y_2, pos_z_2)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	var17 = event.GetRefAngle(pos_x_2, pos_y_2, pos_z_2, pos_x, pos_y, pos_z) or var17
	var17 = event.AngleLimit(var17) or var17
	if active_chr_no == 0 then
		var17 = vm.f32(var17 + vm.f32(2.9))
	end
	if active_chr_no == 1 then
		var17 = vm.f32(var17 + vm.f32(2.4))
	end
	var17 = event.AngleLimit(var17) or var17
	var8 = vm.f32(vm.f32(vm.sin(var17) * 14.0) + pos_x_2)
	var10 = vm.f32(vm.f32(vm.cos(var17) * 14.0) + pos_z_2)
	event.SetCharaPos(0, var8, var9, var10)
	var17 = vm.f32(var17 - vm.f32(3.1415927))
	var17 = event.AngleLimit(var17) or var17
	event.SetCharaRot(0, 0.0, var17, 0.0)
	event.EohResetDaPosition(0)
	event.LoadChara(5, "event/itemget_ev/itemget_ev.gltf", "info", 12)
	event.CharaActive(0, 12)
	if active_chr_no == 0 then
		event.SetCameraCtrl(0)
		event.SetFcameraFollowFlag(1)
		event.SetFcameraFollowA(var8, var9 + 18.0, var10)
		event.SetCameraSpeed(16.0)
		event.SetFcameraFollowOfs(0.0, 6.0, 0.0)
		event.SetFcameraHeight(-14.0)
		event.SetFcameraDist(54.0)
		event.SetCharaPos(12, var8, var9 + 36.0, var10)
	end
	if active_chr_no == 1 then
		event.SetCameraCtrl(0)
		event.SetFcameraFollowFlag(1)
		event.SetFcameraFollowA(var8, var9 + 18.0, var10)
		event.SetCameraSpeed(16.0)
		event.SetFcameraFollowOfs(0.0, 0.0, 0.0)
		event.SetFcameraHeight(-5.0)
		event.SetFcameraDist(34.0)
		var18 = vm.f32(vm.f32(vm.sin(var17) * 8.0) + var8)
		var19 = vm.f32(var9 + 18.0)
		var20 = vm.f32(vm.f32(vm.cos(var17) * 8.0) + var10)
		event.SetCharaPos(12, var18, var19, var20)
	end
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 0)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 0)
	event.SetCrossfade(30)
	event.ObjsSetMotion(0, "取る", 6)
	event.ObjsNextMotion(0, "取るL", 4)
	helper_cc3c3399(16)
	if vm.skipping() then
		return skip(7)
	end
	event.SndSePlay(var4, 0)
	helper_cc3c3399(2)
	if vm.skipping() then
		return skip(8)
	end
	event.EohSetPos(1, 0.0, 0.0, 0.0)
	event.GeostoneSetReference(0, "item")
	helper_cc3c3399(10)
	if vm.skipping() then
		return skip(9)
	end
	do
		local out1, out2, out3 = event.GetCameraPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var17 = event.GetRefAngle(var8, var9, var10, pos_x, pos_y, pos_z) or var17
	event.SetCharaRot(12, 0.0, var17, 0.0)
	event.CharaActive(1, 12)
	event.EohSyncChara(4, 12)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ObjsSetMotion(4, "発動", 6, 1.2)
	event.ObjsMotionWait(4)
	event.ObjsResetMotion(4)
	event.ObjsSetMotion(4, "発動", 5)
	helper_cc3c3399(20)
	if vm.skipping() then
		return skip(10)
	end
	event.SndSePlay(var4, 1)
	helper_4457cf9b(0)
	if vm.skipping() then
		return skip(11)
	end
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	argc = event.GetSysSndId() or argc
	event.SndSePlay(argc, 18)
	helper_20c72d9f(0, 2400, 8, 0, 0)
	if vm.skipping() then
		return skip(12)
	end
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	stage_id = event.DngGetStageId() or stage_id
	var23 = event.DngGetFloorId() or var23
	event.SetFloorInfo(stage_id, var23, 5, 256)
	event.SetCrossfade(10)
	if active_chr_no == 1 then
		event.SetMotion(0, "取る戻り", 6)
		if vm.wait() then
			return skip(13)
		end
	end
	event.DngPause(529, 0)
	event.SetMotion(0, "立ち", 4)
	event.SetCharaPos(0, var1, var2, var3)
	event.EohResetDaPosition(0)
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 1)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 1)
	event.GeostoneDelReference()
	event.GeostoneSetFlag(0)
	event.EohSetScale(1, 1.0, 1.0, 1.0)
	event.DelExtMotion(0)
	event.DeleteChara(12)
	event.SetCameraCtrl(1)
	event.Finish()
end

--- Program 1200.
script[1200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_dc16211f(0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 1500.
script[1500] = function()
	local var0: s32 = 0
	local stage_id: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_cc3c3399(30)
		end
		if at <= 2 then
			helper_093c85e9()
		end
	end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.ActchrSetDefMotion(0, 4)
	event.FadeOutBgm(60)
	var0 = event.GetCnt(17) or var0
	if bit32.band(var0, 256) == 0 then
		event.PostTreasureBox(50.0, 0.0, 600.0, 3.14, 189)
	end
	if bit32.band(var0, 512) == 0 then
		event.PostTreasureBox(-50.0, 0.0, 600.0, 3.14, 189)
	end
	if bit32.band(var0, 256) == 0 or bit32.band(var0, 512) == 0 then
		event.SetCrossfade(30)
		event.SetCameraPos(-6.4, 43.21, 329.72)
		event.SetCameraRef(-3.01, 30.0, 440.22)
		event.SetCharaPos(0, -3.03, 0.0, 439.67)
		event.SetCharaRot(0, 0.0, 0.03, 0.0)
		helper_cc3c3399(30)
		if vm.skipping() then
			return skip(2)
		end
		event.ResetCamera(0)
	end
	event.SetLoadbgFile("snd2/bgm/bg_193.sound.json")
	helper_093c85e9()
	if vm.skipping() then
		return skip(3)
	end
	event.LoadBgmPack(193)
	event.PlayBgm(0)
	stage_id = event.DngGetStageId() or stage_id
	var2 = event.DngGetFloorId() or var2
	event.SetFloorInfo(stage_id, var2, 5, 2)
	event.Finish()
end

--- Program 2500.
script[2500] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	event.DngPause(513, 1)
	event.SetFlag(50, 1)
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	helper_20c72d9f(0, 2600, 8, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	if vm.wait() then
		return skip(2)
	end
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	event.DngPause(513, 0)
	event.Finish()
end

--- Program 2510.
script[2510] = function()
	local var0: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			_, var0 = helper_dc405d6a(0, 0, var0)
		end
		helper_9660e7cc(0)
	end
	event.Initialize()
	event.DngPause(515, 1)
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	helper_9ac5c278(0, 2610, 8, 0, 0)
	helper_cc3c3399(30)
	if vm.skipping() then
		return skip(1)
	end
	_, var0 = helper_dc405d6a(0, 0, var0)
	if vm.skipping() then
		return skip(2)
	end
	helper_9660e7cc(0)
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	event.DngPause(515, 0)
	event.Finish()
end

--- Program 2520.
script[2520] = function()
	local var0: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			_, var0 = helper_dc405d6a(0, 0, var0)
		end
		if at <= 2 then
			helper_9660e7cc(0)
			helper_20c72d9f(0, 2621, 8, 0, 0)
		end
		if at <= 3 then
			helper_20c72d9f(0, 2622, 8, 0, 0)
		end
		if at <= 4 then
			helper_20c72d9f(0, 2623, 8, 0, 0)
		end
		if at <= 5 then
			helper_20c72d9f(0, -1, 8, 0, 0)
		end
	end
	event.Initialize()
	event.DngPause(515, 1)
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	helper_9ac5c278(0, 2620, 8, 0, 0)
	helper_cc3c3399(30)
	if vm.skipping() then
		return skip(1)
	end
	_, var0 = helper_dc405d6a(0, 0, var0)
	if vm.skipping() then
		return skip(2)
	end
	helper_9660e7cc(0)
	helper_20c72d9f(0, 2621, 8, 0, 0)
	if vm.skipping() then
		return skip(3)
	end
	helper_20c72d9f(0, 2622, 8, 0, 0)
	if vm.skipping() then
		return skip(4)
	end
	helper_20c72d9f(0, 2623, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, 'Mehr erf[UNI00e4]hrst du unter\n"Hilfe" im Hauptmen[UNI00fc].')
	helper_20c72d9f(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(6)
	end
	if vm.wait() then
		return skip(7)
	end
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	event.DngPause(515, 0)
	event.Finish()
end

--- Program 2530.
script[2530] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	event.DngPause(513, 1)
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	event.MesMake_2(
		0,
		"[(!)]Lenken des Buggys\n   Beschleunige mit (L)↑, bremse mit (L)↓.\n   lenke mit (L) ← oder →.\n   Scharfe Kurven: [l1] + (L) ← oder →."
	)
	helper_20c72d9f(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	if vm.wait() then
		return skip(2)
	end
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	event.DngPause(513, 0)
	event.Finish()
end

--- Program 2540.
script[2540] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_20c72d9f(0, -1, 8, 0, 0)
		end
		if at <= 2 then
			helper_20c72d9f(0, -1, 8, 0, 0)
		end
		if at <= 3 then
			helper_20c72d9f(0, -1, 8, 0, 0)
		end
		if at <= 4 then
			helper_20c72d9f(0, -1, 8, 0, 0)
		end
	end
	event.Initialize()
	event.DngPause(515, 1)
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	event.MesMake_2(0, "[(!)]Du kannst die Magie-Raub-\nKlinge jetzt verwenden.")
	helper_20c72d9f(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"Die Fertigkeit Magie-Raub-Klinge\nerlaubt es dir, die Energie von\nElementarangriffen wie Feuer beim\nAbwehren aufzunehmen.<page>Beim Angriff verwandelt\nsie sich in Magie."
	)
	helper_20c72d9f(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(
		0,
		"Die Energie eines Elements kannst\ndu immer weiter aufladen.\nNimmst du aber einen anderen Elementar-\nTyp auf, verlierst du die ganze Ladung."
	)
	helper_20c72d9f(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(
		0,
		"Wie viel Elementarenergie du\nabsorbieren kannst, h[UNI00e4]ngt von der\nHaltbarkeit deiner Waffe ab."
	)
	helper_20c72d9f(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"Um absorbierte Elementarenergie als\nMagie abzugeben, dr[UNI00fc]cke [l1]\n w[UNI00e4]hrend du mit [r1] abwehrst."
	)
	helper_20c72d9f(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	if vm.wait() then
		return skip(6)
	end
	event.SetMesWindowMode(0, 1)
	event.SetMesDrawspeed(0, 0)
	event.DngPause(515, 0)
	event.Finish()
end

return script
