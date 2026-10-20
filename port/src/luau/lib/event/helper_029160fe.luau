--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_184013af = require("@lib/event/helper_184013af")
local helper_1f9a3afd = require("@lib/event/helper_1f9a3afd")
local helper_27ff0b8f = require("@lib/event/helper_27ff0b8f")
local helper_57ae27b6 = require("@lib/event/helper_57ae27b6")
local helper_6c719c99 = require("@lib/event/helper_6c719c99")
local helper_8f31f334 = require("@lib/event/helper_8f31f334")
local helper_a03e568e = require("@lib/event/helper_a03e568e")
local helper_aafd6a80 = require("@lib/event/helper_aafd6a80")
local helper_ce11f726 = require("@lib/event/helper_ce11f726")
local helper_dd7a6f53 = require("@lib/event/helper_dd7a6f53")

--- Helper function.
local function helper_029160fe()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 24 then
			if at <= 1 then
				helper_1f9a3afd(6000260, 90)
			end
			if at <= 2 then
				helper_8f31f334(0)
			end
			if at <= 3 then
				helper_8f31f334(1)
			end
			if at <= 4 then
				helper_184013af()
			end
			if at <= 5 then
				helper_8f31f334(0)
			end
			if at <= 6 then
				helper_8f31f334(1)
			end
			if at <= 7 then
				helper_8f31f334(2)
			end
			if at <= 8 then
				helper_6c719c99(6000270)
			end
			if at <= 9 then
				helper_8f31f334(1)
			end
			if at <= 10 then
				helper_57ae27b6(1)
			end
			if at <= 11 then
				helper_27ff0b8f(0, -1, 8, 0, 0)
				helper_ce11f726(0)
			end
			if at <= 12 then
				helper_dd7a6f53(0)
				helper_8f31f334(1)
			end
			if at <= 13 then
				helper_a03e568e(6000290, -1, 4)
			end
			if at <= 14 then
				helper_8f31f334(2)
			end
			if at <= 15 then
				helper_6c719c99(6000300)
			end
			if at <= 16 then
				helper_8f31f334(1)
			end
			if at <= 17 then
				helper_6c719c99(6000310)
			end
			if at <= 18 then
				helper_8f31f334(0)
			end
			if at <= 19 then
				helper_8f31f334(1)
			end
			if at <= 20 then
				helper_6c719c99(6000320)
			end
			if at <= 21 then
				helper_8f31f334(2)
			end
			if at <= 22 then
				helper_8f31f334(2)
			end
			if at <= 23 then
				helper_aafd6a80(30)
			end
			if vm.skip_end() then
				return skip(25)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var0, 5)
		event.StopBgm(0)
		event.CharaActive(0)
		event.CharaActive(32)
		event.CharaActive(33)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(32)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.LoadMes(0, -1)
	end
	event.SetFlag(600, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(4524)
	var0 = event.SndLoadSound(4524) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e600/e600/")
	event.LoadMes(0, 5, "e600_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e600_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e600_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e600_osmond.gltf", "info", 34)
	event.CharaActive(34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 32)
		event.LoadEquip(5, 0, 4, "info", 32)
		event.LoadEquip(5, 0, 3, "info", 32)
		event.LoadEquip(5, 0, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e600/e600/e600_mints.gltf", "info", 32)
		event.EohSyncChara(0, 32)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 32)
		event.LoadEquip(5, 1, 4, "info", 32)
		event.LoadEquip(5, 1, 3, "info", 32)
		event.LoadEquip(5, 1, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e600/e600/e600_monica.gltf", "info", 32)
		event.EohSyncChara(1, 32)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.CharaActive(32)
	event.CharaActive(33)
	event.EohSyncObj(3, "p02_s3701-0")
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.EohSyncObj(4, "p06_s3701-0")
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.EohSyncObj(5, "p02_s3701-1")
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.EohSyncObj(6, "p06_s3701-1")
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.EohSetPos(0, -10.0, 0.4, 20.0)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSetFootSoundId(0, 23)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "うれし顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetSoundId(0, var0)
	event.EohSetPos(1, 10.0, 0.4, 0.0)
	event.EohSetRot(1, 0.0, 0.0, 0.0)
	event.EohSetFootSoundId(1, 23)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "不満顔")
	event.EohSetTexAnim(1, 1, "不満目パチ")
	event.EohSetPos(2, 0.0, 6.0, 166.5)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetMotion(2, "カチャカチャ", 4)
	event.EohSetRot(3, 0.0, 0.9, 0.0)
	event.EohSetRot(4, 0.0, 0.9, 0.0)
	event.EohSetRot(5, 0.0, -0.9, 0.0)
	event.EohSetRot(6, 0.0, -0.9, 0.0)
	event.InitDramaScene()
	var2 = vm.f32(vm.f32(vm.sin(vm.f32(0.9)) * 10.0) + vm.f32(-39.016))
	var3 = vm.f32(0.4)
	var4 = vm.f32(vm.f32(vm.cos(vm.f32(0.9)) * 10.0) + vm.f32(140.882))
	event.ObjsMove(0, -10.0, 0.4, 120.0, 120, 1)
	event.ObjsMove(0, var2, var3, var4, 40, 1)
	event.ObjsRotDelay(0, 116)
	event.ObjsRotation(0, 0.0, -0.72, 0.0, 10)
	event.ObjsRotDelay(0, 26)
	event.ObjsRotation(0, 0.0, 0.9, 0.0, 10)
	event.ObjsSetMotion(0, "キョロキョロ歩き", 4)
	event.ObjsMotionDelay(0, 160)
	event.ObjsSetMotion(0, "座る", 2)
	event.ObjsNextMotion(0, "座るL", 4)
	event.ObjsPosDelay(0, 10)
	event.ObjsMove(0, -39.016, 0.4, 140.882, 10, 1)
	event.ObjsSeDelay(0, 180)
	event.ObjsSePlay(0, var0, 6)
	var5 = vm.f32(vm.f32(vm.sin(vm.f32(-0.9)) * 4.0) + vm.f32(39.016))
	var6 = vm.f32(0.4)
	var7 = vm.f32(vm.f32(vm.cos(vm.f32(-0.9)) * 4.0) + vm.f32(140.882))
	event.ObjsMove(1, 10.0, 0.4, 120.0, 140, 1)
	event.ObjsMove(1, var5, var6, var7, 40, 1)
	event.ObjsRotDelay(1, 136)
	event.ObjsRotation(1, 0.0, 0.72, 0.0, 10)
	event.ObjsRotDelay(1, 26)
	event.ObjsRotation(1, 0.0, -0.9, 0.0, 10)
	event.ObjsSetMotion(1, "歩き", 4)
	event.ObjsMotionDelay(1, 176)
	event.ObjsSetMotion(1, "立ち")
	event.ObjsMotionDelay(1, 4)
	event.ObjsSetMotion(1, "すわり", 2)
	event.ObjsNextMotion(1, "すわりL", 4)
	event.ObjsPosDelay(1, 10)
	event.ObjsMove(1, 39.016, 0.4, 140.882, 10, 1)
	event.ObjsSeDelay(1, 200)
	event.ObjsSePlay(1, var0, 6)
	event.SndSePlay(var0, 5)
	event.CmrsInit()
	event.CmrsSetPos(33.53, 60.0, 94.399994)
	event.CmrsSetRef(13.04, 24.91, 34.309998)
	event.CmrsMove2(33.53, 60.0, 224.4, 13.04, 24.91, 164.31, 140, 2, 1.0)
	event.SetFadeIn(30)
	event.SetPakuAnim(0, "わらい口パク")
	helper_1f9a3afd(6000250, 60)
	if vm.skipping() then
		return skip(1)
	end
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "不満顔")
	event.EohSetTexAnim(1, 1, "不満目～ひき目")
	event.SetPakuAnim(1, "通常口パク")
	helper_1f9a3afd(6000260, 90)
	if vm.skipping() then
		return skip(2)
	end
	helper_8f31f334(0)
	if vm.skipping() then
		return skip(3)
	end
	event.SndSePlay(var0, 7)
	event.ObjsRotation2(0, 0.0, -0.7, 0.0, 16, 0, 1.0)
	event.ObjsRotation2(4, 0.0, -0.7, 0.0, 16, 0, 1.0)
	helper_8f31f334(1)
	if vm.skipping() then
		return skip(4)
	end
	event.SndSePlay(var0, 7)
	event.ObjsRotation2(1, 0.0, 0.7, 0.0, 16, 0, 1.0)
	event.ObjsRotation2(6, 0.0, 0.7, 0.0, 16, 0, 1.0)
	helper_184013af()
	if vm.skipping() then
		return skip(5)
	end
	helper_8f31f334(0)
	if vm.skipping() then
		return skip(6)
	end
	helper_8f31f334(1)
	if vm.skipping() then
		return skip(7)
	end
	event.SndSeStop(var0, 5)
	event.SndSePlay(var0, 8)
	event.ObjsMotionWait(2)
	event.ObjsSetMotion(2, "座り２", 4)
	helper_8f31f334(2)
	if vm.skipping() then
		return skip(8)
	end
	helper_6c719c99(6000270)
	if vm.skipping() then
		return skip(9)
	end
	event.SndSePlay(var0, 9)
	event.ObjsRotation2(1, 0.0, -0.5, 0.0, 16, 0, 1.0)
	event.ObjsRotation2(6, 0.0, -0.5, 0.0, 16, 0, 1.0)
	helper_8f31f334(1)
	if vm.skipping() then
		return skip(10)
	end
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "不満顔")
	event.EohSetTexAnim(1, 1, "ひき目～通常目")
	event.ObjsSetMotion(1, "すわり会話", 2)
	event.ObjsNextMotion(1, "すわりL", 4)
	event.SetPakuAnim(1, "通常口パク", "口とじ～間とじ")
	event.StreamOpen3(1, 6000280)
	helper_57ae27b6(1)
	if vm.skipping() then
		return skip(11)
	end
	event.StreamPlay(1)
	event.MesMake_2(0, 6000280)
	helper_27ff0b8f(0, -1, 8, 0, 0)
	helper_ce11f726(0)
	if vm.skipping() then
		return skip(12)
	end
	helper_dd7a6f53(0)
	event.StreamClose(1)
	helper_8f31f334(1)
	if vm.skipping() then
		return skip(13)
	end
	event.SndSePlay(var0, 10)
	event.ObjsSetMotion(2, "振り向く（座り）", 6, 0.6)
	event.ObjsNextMotion(2, "振り向くループ", 4)
	helper_a03e568e(6000290, -1, 4)
	if vm.skipping() then
		return skip(14)
	end
	event.SetMesOkuri(0, 1)
	helper_8f31f334(2)
	if vm.skipping() then
		return skip(15)
	end
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "不満顔")
	event.EohSetTexAnim(1, 1, "通常目～あいそ目")
	event.ObjsSetMotion(1, "はは、いいです", 2)
	event.ObjsNextMotion(1, "すわりL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_6c719c99(6000300)
	if vm.skipping() then
		return skip(16)
	end
	helper_8f31f334(1)
	if vm.skipping() then
		return skip(17)
	end
	event.CmrsSetPos(-56.79, 19.84, 145.38)
	event.CmrsSetRef(-39.26, 20.59, 138.61)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "まばたき目パチ")
	event.ObjsSetMotion(2, "座り２", 4)
	event.ObjsSetMotion(0, "行こう！", 4)
	event.ObjsRotation2(1, 0.0, 0.7, 0.0, 16, 0, 1.0)
	event.ObjsRotation2(6, 0.0, 0.7, 0.0, 16, 0, 1.0)
	event.SetPakuAnim(0, "わらい口パク")
	helper_6c719c99(6000310)
	if vm.skipping() then
		return skip(18)
	end
	helper_8f31f334(0)
	if vm.skipping() then
		return skip(19)
	end
	helper_8f31f334(1)
	if vm.skipping() then
		return skip(20)
	end
	event.CmrsSetPos(0.0, 38.05, 203.65)
	event.CmrsSetRef(-0.0, 19.67, 164.42)
	event.SetProjection(331.9)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "あきれ目とじ")
	event.EohSetTexAnim(1, 1, "半口")
	event.ObjsSetMotion(0, "いざ", 4)
	event.ObjsSetMotion(2, "いざ", 6)
	event.ObjsNextMotion(2, "いざループ", 4)
	event.ObjsSetMotion(1, "頭抱えL", 4)
	helper_6c719c99(6000320)
	if vm.skipping() then
		return skip(21)
	end
	helper_8f31f334(2)
	if vm.skipping() then
		return skip(22)
	end
	event.ObjsMotionWait(2)
	event.ObjsSetMotion(2, "カチッ", 6)
	event.ObjsNextMotion(2, "カチッループ", 4)
	event.ObjsSeDelay(2, 8)
	event.ObjsSePlay(2, var0, 12)
	event.ObjsSeDelay(2, 10)
	event.ObjsSePlay(2, var0, 13)
	helper_8f31f334(2)
	if vm.skipping() then
		return skip(23)
	end
	event.SndSePlay(var0, 14)
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(24)
	end
	return part2()
end

return helper_029160fe
