--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_12e48d20 = require("@lib/event/helper_12e48d20")
local helper_2e8cfc5c = require("@lib/event/helper_2e8cfc5c")
local helper_34ac0071 = require("@lib/event/helper_34ac0071")
local helper_41c448af = require("@lib/event/helper_41c448af")
local helper_474c5bc8 = require("@lib/event/helper_474c5bc8")
local helper_8893edb6 = require("@lib/event/helper_8893edb6")
local helper_a88b23ab = require("@lib/event/helper_a88b23ab")
local helper_be5e42c1 = require("@lib/event/helper_be5e42c1")
local helper_cf969bc0 = require("@lib/event/helper_cf969bc0")
local helper_f48d7d30 = require("@lib/event/helper_f48d7d30")

--- Helper function.
local function helper_8679ad6e()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local rot_x: f32 = 0
	local rot_y: f32 = 0
	local var4: f32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: s32 = 0
	local var15: s32 = 0
	local var16: s32 = 0
	local stream_open_state: s32 = 0
	local var18: s32 = 0
	local var19: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 62 then
			if at <= 2 then
				var4 = vm.f32(vector_z - vm.f32(3.1415927))
				helper_41c448af(1)
			end
			if at <= 3 then
				helper_12e48d20(4080010)
			end
			if at <= 4 then
				helper_12e48d20(4080020)
			end
			if at <= 5 then
				helper_12e48d20(4080030)
			end
			if at <= 6 then
				var11 = -140.0
				var12 = vm.f32(1.9)
				var13 = vm.f32(-0.044)
				var15 = 0
				var16 = 0
				var14 = 0
				var11 = vm.f32(var11 + var12)
				var12 = vm.f32(var12 + var13)
				var15 = 0
				var16 = 1
				var16 = 0
				helper_2e8cfc5c(0, -1, 8, 0, 0)
				var18 = 4080040
				var15 = 1
				helper_be5e42c1(0)
				var18 = 4080045
				var15 = 1
				var14 = var14 + 1
			end
			if at <= 7 then
				helper_be5e42c1(0)
				helper_12e48d20(4080050)
			end
			if at <= 8 then
				helper_12e48d20(4080060)
			end
			if at <= 9 then
				helper_12e48d20(4080070)
			end
			if at <= 10 then
				helper_41c448af(0)
			end
			if at <= 11 then
				helper_12e48d20(4080080)
			end
			if at <= 12 then
				helper_12e48d20(4080090)
			end
			if at <= 13 then
				helper_41c448af(0)
			end
			if at <= 14 then
				helper_474c5bc8(50)
			end
			if at <= 15 then
				helper_41c448af(3)
			end
			if at <= 16 then
				helper_474c5bc8(4)
			end
			if at <= 17 then
				helper_34ac0071()
			end
			if at <= 18 then
				helper_12e48d20(4080100)
			end
			if at <= 19 then
				helper_12e48d20(4080110)
			end
			if at <= 20 then
				helper_474c5bc8(10)
			end
			if at <= 21 then
				helper_41c448af(0)
			end
			if at <= 22 then
				helper_41c448af(3)
			end
			if at <= 23 then
				helper_12e48d20(4080120)
			end
			if at <= 24 then
				helper_41c448af(0)
			end
			if at <= 25 then
				helper_12e48d20(4080130)
			end
			if at <= 26 then
				helper_12e48d20(4080140)
			end
			if at <= 27 then
				helper_12e48d20(4080150)
			end
			if at <= 28 then
				helper_474c5bc8(90)
			end
			if at <= 29 then
				helper_474c5bc8(10)
			end
			if at <= 30 then
				helper_f48d7d30(4080160, 50)
			end
			if at <= 31 then
				helper_41c448af(2)
			end
			if at <= 32 then
				helper_12e48d20(4080170)
			end
			if at <= 33 then
				helper_41c448af(2)
			end
			if at <= 34 then
				helper_12e48d20(4080180)
			end
			if at <= 35 then
				helper_12e48d20(4080185)
			end
			if at <= 36 then
				helper_474c5bc8(10)
			end
			if at <= 37 then
				helper_cf969bc0(4080190, -1, 0)
			end
			if at <= 38 then
				var19 = helper_8893edb6(1)
			end
			if at <= 39 then
				helper_2e8cfc5c(0, -1, 8, 0, 0)
				helper_474c5bc8(vm.i32(30 - var19))
			end
			if at <= 40 then
				helper_474c5bc8(14)
			end
			if at <= 41 then
				helper_be5e42c1(0)
				helper_474c5bc8(10)
			end
			if at <= 42 then
				helper_474c5bc8(4)
			end
			if at <= 43 then
				helper_474c5bc8(3)
			end
			if at <= 44 then
				helper_a88b23ab()
			end
			if at <= 45 then
				helper_474c5bc8(2)
			end
			if at <= 46 then
				helper_f48d7d30(4080205, 40)
			end
			if at <= 47 then
				helper_a88b23ab()
			end
			if at <= 48 then
				helper_12e48d20(4080210)
			end
			if at <= 49 then
				helper_474c5bc8(2)
			end
			if at <= 50 then
				helper_474c5bc8(8)
			end
			if at <= 51 then
				helper_41c448af(2)
			end
			if at <= 52 then
				helper_474c5bc8(4)
			end
			if at <= 53 then
				helper_474c5bc8(10)
			end
			if at <= 54 then
				helper_41c448af(2)
			end
			if at <= 55 then
				helper_12e48d20(4080220)
			end
			if at <= 56 then
				helper_12e48d20(4080230)
			end
			if at <= 57 then
				helper_41c448af(5)
			end
			if at <= 58 then
				helper_474c5bc8(10)
			end
			if at <= 59 then
				helper_474c5bc8(4)
			end
			if at <= 60 then
				helper_474c5bc8(6)
			end
			if at <= 61 then
				helper_474c5bc8(30)
			end
			if vm.skip_end() then
				return skip(63)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var0, 2)
		event.SndSeStop(var0, 5)
		event.SndSeStop(var0, 6)
		event.SndSeStop(var0, 8)
		event.SndSeStop(var0, 9)
		event.SndSeStop(var0, 11)
		event.StopBgm(0)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.EohSetMotion(0, "立ち", 4)
		event.EohSetMotion(1, "立ち", 4)
		event.EohSetRot(4, vector_x, vector_y, vector_z)
		event.EohSetPos(5, pos_x, pos_y, pos_z)
		event.DelExtMotion(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.DeleteChara(13)
		event.LoadMes(0, -1)
		event.SetStatusbarShow(1, 1.0)
		event.EohSetShow(6, 1)
		event.EohSetShow(7, 1)
		event.BgmLoadCancel()
		event.Finish()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(408, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.LoadSound(4803)
	var0 = event.SndLoadSound(4803) or var0
	event.SndSePlay(var0, 11)
	if vm.wait() then
		return skip(2)
	end
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e400/e408/")
	event.LoadMes(0, 5, "e408_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e408_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e408_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e408_paw.gltf", "info", 10)
	event.CharaActive(0, 10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e408_shigu.gltf", "info", 11)
	event.CharaActive(0, 11)
	event.EohSyncChara(3, 11)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.LoadChara(5, "mariometto_a.gltf", "info", 12)
	event.CharaActive(0, 12)
	event.SetReference(11, "metto_null", 12)
	event.LoadChara(5, "e408_mizusibuki.gltf", "info", 13)
	event.CharaActive(0, 13)
	event.SetCharaType(13, 4)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 8)
		event.LoadEquip(5, 0, 4, "info", 8)
		event.LoadEquip(5, 0, 3, "info", 8)
		event.LoadEquip(5, 0, 2, "info", 8, 9)
		event.LoadMotion(5, "event/e400/e408/e408_mints.gltf", "info", 8)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 8)
		event.EohSyncChara(0, 8)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 8)
		event.LoadEquip(5, 1, 4, "info", 8)
		event.LoadEquip(5, 1, 3, "info", 8)
		event.LoadEquip(5, 1, 2, "info", 8, 9)
		event.LoadMotion(5, "event/e400/e408/e408_monica.gltf", "info", 8)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 8)
		event.EohSyncChara(1, 8)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(8)
	event.CharaActive(9)
	event.EohSyncChara(6, 1)
	event.EohSyncChara(7, 2)
	event.EohSyncObj(4, "p06_s19", "s19_09-m1")
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.EohSyncObj(5, "p06_s19", "s19_10-m1")
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.EohSetPos(0, -70.0, 5.18, 610.0)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetFootSoundId(0, 16)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "無表情")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetPos(1, -85.0, 5.18, 620.0)
	event.EohSetRot(1, 0.0, 3.14, 0.0)
	event.EohSetFootSoundId(1, 16)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.EohSetPos(2, -76.0, -38.33, 1157.0)
	event.EohSetRot(2, 0.0, 3.14, 0.0)
	event.EohSetFootSoundId(2, 16)
	event.EohSetPos(3, -68.33, -4.68, 302.5)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.EohSetMotion(3, "出現", 5)
	event.EohSetTexAnim(3, 0)
	event.EohSetTexAnim(3, 1, "赤目パチ")
	event.SetCharaPos(13, -72.26, 0.0, 371.59)
	event.SetCharaRot(13, 0.0, -0.12, 0.0)
	event.EohSetShow(6, 0)
	event.EohSetShow(7, 0)
	do
		local out1, out2, out3 = event.EohGetRot(4)
		rot_x = out1 or rot_x
		rot_y = out2 or rot_y
		var4 = out3 or var4
	end
	do
		local out1, out2, out3 = event.CopyVector(rot_x, rot_y, var4)
		vector_x = out1 or vector_x
		vector_y = out2 or vector_y
		vector_z = out3 or vector_z
	end
	do
		local out1, out2, out3 = event.EohGetPos(5)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var4 = vm.f32(vector_z - vm.f32(3.1415927))
	var4 = event.AngleLimit(var4) or var4
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(-78.09, 35.57, 471.0)
	event.CmrsSetRef(-77.73, 22.13, 561.51)
	event.ObjsMove(0, -70.0, 4.89, 540.0, 60, 1)
	event.ObjsSetMotion(0, "歩き", 4)
	event.ObjsMotionDelay(0, 60)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsMove(1, -85.0, 5.18, 540.0, 70, 1)
	event.ObjsSetMotion(1, "歩き", 4)
	event.ObjsMotionDelay(1, 70)
	event.ObjsSetMotion(1, "立ち")
	event.SetFadeIn(30)
	helper_41c448af(1)
	if vm.skipping() then
		return skip(3)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_12e48d20(4080010)
	if vm.skipping() then
		return skip(4)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_12e48d20(4080020)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(-80.97, 22.27, 518.15)
	event.CmrsSetRef(-69.62, 27.4, 537.26)
	event.SetPakuAnim(0, "通常口パク")
	helper_12e48d20(4080030)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMesOkuri(0, 0)
	var11 = -140.0
	var12 = vm.f32(1.9)
	var13 = vm.f32(-0.044)
	event.CmrsSetPos(-86.24, 243.02, 628.3)
	event.CmrsSetRef(var11, 253.78, 519.17)
	var15 = 0
	var16 = 0
	var14 = 0
	while var14 < 440 do
		event.CmrsSetRef(var11, 253.78, 519.17)
		var11 = vm.f32(var11 + var12)
		if var14 < 42 then
			var12 = vm.f32(var12 + var13)
		end
		if var15 == 1 then
			stream_open_state = event.StreamOpenCheck() or stream_open_state
			if stream_open_state == 0 then
				var15 = 0
				var16 = 1
				event.StreamStandby(1)
			end
		end
		if var16 == 1 then
			stream_open_state = event.StreamOpenCheck() or stream_open_state
			if stream_open_state == 0 then
				var16 = 0
				event.MesMake_2(0, var18)
				helper_2e8cfc5c(0, -1, 8, 0, 0)
				event.StreamPlay(1)
			end
		end
		if var14 == 0 then
			var18 = 4080040
			event.StreamOpen3(1, var18)
			var15 = 1
		end
		if var14 == 180 then
			helper_be5e42c1(0)
			event.StreamClose(1)
			var18 = 4080045
			event.StreamOpen3(1, var18)
			var15 = 1
		end
		var14 = var14 + 1
		if vm.wait() then
			return skip(7)
		end
	end
	helper_be5e42c1(0)
	event.StreamClose(1)
	event.SetMesOkuri(0, 1)
	event.CmrsSetPos(-71.52, 55.19, 769.57)
	event.CmrsSetRef(-78.08, 79.65, 504.61)
	event.SetPakuAnim(0, "通常口パク")
	helper_12e48d20(4080050)
	if vm.skipping() then
		return skip(8)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_12e48d20(4080060)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsSetMotion(0, "左向く", 6)
	event.ObjsNextMotion(0, "左向くL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_12e48d20(4080070)
	if vm.skipping() then
		return skip(10)
	end
	helper_41c448af(0)
	if vm.skipping() then
		return skip(11)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_12e48d20(4080080)
	if vm.skipping() then
		return skip(12)
	end
	helper_12e48d20(4080090)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsSetMotion(0, "左向く戻り", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	helper_41c448af(0)
	if vm.skipping() then
		return skip(14)
	end
	event.CharaActive(11)
	event.CharaActive(12)
	event.ObjsSetMotion(3, "出現", 6)
	event.ObjsNextMotion(3, "出現L", 4)
	event.CharaActive(1, 13)
	event.SetMotion(13, "出現", 6)
	event.SndSePlay(var0, 2)
	helper_474c5bc8(50)
	if vm.skipping() then
		return skip(15)
	end
	event.CmrsSetPos(-79.56, 83.32, 667.05)
	event.CmrsSetRef(-76.25, 31.32, 465.62)
	event.ObjsSetMotion(0, "驚く", 6)
	event.ObjsNextMotion(0, "驚くL", 4)
	event.ObjsSetMotion(1, "びっくりから上見", 6)
	event.ObjsNextMotion(1, "上向くL", 4)
	helper_41c448af(3)
	if vm.skipping() then
		return skip(16)
	end
	event.StopBgm(0)
	event.SetLoadbgFile("snd2/bgm/bg_191.sound.json")
	helper_474c5bc8(4)
	if vm.skipping() then
		return skip(17)
	end
	helper_34ac0071()
	if vm.skipping() then
		return skip(18)
	end
	event.LoadBgmPack(191)
	event.PlayBgm(0)
	event.CmrsSetPos(-82.34, 24.64, 525.1)
	event.CmrsSetRef(-68.49, 28.0, 544.23)
	event.CharaActive(0, 13)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おこり目パチ")
	event.SetPakuAnim(0, "大口パク")
	helper_12e48d20(4080100)
	if vm.skipping() then
		return skip(19)
	end
	event.CmrsSetPos(-73.64, 31.85, 524.1)
	event.CmrsSetRef(-86.33, 28.93, 539.68)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.SetPakuAnim(1, "通常口パク")
	helper_12e48d20(4080110)
	if vm.skipping() then
		return skip(20)
	end
	event.CmrsSetPos(-80.48, 94.7, 723.29)
	event.CmrsSetRef(-76.25, 38.16, 465.62)
	event.ObjsSetPos(3, -78.11, -15.13, 426.88)
	event.ObjsSetMotion(3, "攻撃", 6)
	event.ObjsNextMotion(3, "立ち2", 4)
	helper_474c5bc8(10)
	if vm.skipping() then
		return skip(21)
	end
	event.SndSePlay(var0, 3)
	event.ObjsMove(0, -44.9, 3.81, 599.34, 20)
	event.ObjsRotation(0, 0.0, 0.38, 0.0, 8)
	event.ObjsRotDelay(0, 4)
	event.ObjsRotation(0, 0.0, -2.98, 0.0, 8)
	event.ObjsSetMotion(0, "走り")
	event.ObjsMotionDelay(0, 20)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsMove(1, -112.34, 5.0, 594.97, 20)
	event.ObjsRotation(1, 0.0, -0.5, 0.0, 8)
	event.ObjsRotDelay(1, 4)
	event.ObjsRotation(1, 0.0, 2.78, 0.0, 8)
	event.ObjsSetMotion(1, "走り")
	event.ObjsMotionDelay(1, 20)
	event.ObjsSetMotion(1, "立ち")
	helper_41c448af(0)
	if vm.skipping() then
		return skip(22)
	end
	helper_41c448af(3)
	if vm.skipping() then
		return skip(23)
	end
	event.CmrsSetPos(-62.07, 18.74, 574.92)
	event.CmrsSetRef(-42.47, 24.02, 598.1)
	event.SndSePlay(var0, 4)
	event.ObjsSetMotion(0, "やめろ", 6)
	event.ObjsNextMotion(0, "驚くL", 4)
	event.SetPakuAnim(0, "大口パク")
	helper_12e48d20(4080120)
	if vm.skipping() then
		return skip(24)
	end
	helper_41c448af(0)
	if vm.skipping() then
		return skip(25)
	end
	event.CmrsSetPos(-90.65, 28.85, 590.7)
	event.CmrsSetRef(-115.93, 29.03, 592.13)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.ObjsSetMotion(1, "上向くL", 4, -1.0, 1)
	event.SetPakuAnim(1, "大口パク")
	helper_12e48d20(4080130)
	if vm.skipping() then
		return skip(26)
	end
	event.CmrsSetPos(-72.77, 80.75, 769.84)
	event.CmrsSetRef(-77.4, 43.66, 562.84)
	event.SndSePlay(var0, 5)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.ObjsSetMotion(3, "威嚇", 6)
	event.ObjsNextMotion(3, "立ち2", 4)
	event.SetPakuAnim(0, "大口パク")
	helper_12e48d20(4080140)
	if vm.skipping() then
		return skip(27)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_12e48d20(4080150)
	if vm.skipping() then
		return skip(28)
	end
	event.SndSeStop(var0, 5)
	event.CmrsSetPos(-76.95, 45.52, 498.09)
	event.CmrsSetRef(-76.43, 15.43, 706.96)
	event.SndSePlay(var0, 6)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おこり目～通常目")
	event.CharaActive(10)
	event.ObjsRotation2(4, rot_x, rot_y, var4, 40, 0, 0.5)
	event.ObjsRotDelay(4, 168)
	event.ObjsRotation2(4, vector_x, vector_y, vector_z, 40, 0, 0.5)
	event.ObjsPosDelay(5, 80)
	event.ObjsMove2(5, pos_x, pos_y + 80.0, pos_z, 32, 1, 0.5)
	event.ObjsPosDelay(5, 40)
	event.ObjsMove2(5, pos_x, pos_y, pos_z, 32, 0, 0.5)
	event.ObjsSetMotion(0, "立ち", 6)
	event.ObjsMotionDelay(0, 4)
	event.ObjsSetMotion(0, "振り向く（左）", 6)
	event.ObjsNextMotion(0, "振り向く（左）L", 4)
	event.ObjsSetMotion(1, "立ち", 6)
	event.ObjsMotionDelay(1, 10)
	event.ObjsSetMotion(1, "振り向き", 6)
	event.ObjsNextMotion(1, "振り向きＬ", 4)
	helper_474c5bc8(90)
	if vm.skipping() then
		return skip(29)
	end
	event.ObjsSetMotion(2, "上見走り")
	event.ObjsMove(2, -76.55, 0.45, 877.82, 60, 1)
	helper_474c5bc8(10)
	if vm.skipping() then
		return skip(30)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_f48d7d30(4080160, 50)
	if vm.skipping() then
		return skip(31)
	end
	helper_41c448af(2)
	if vm.skipping() then
		return skip(32)
	end
	event.CmrsSyncObj(2, 0.0, 18.3, -4.0, -2.0, -0.57, 24.0)
	event.ObjsSetPos(2, -76.0, 1.92, 813.28)
	event.ObjsMove(2, -78.0, 4.89, 551.73, 120, 1)
	event.ObjsMotionDelay(2, 120)
	event.ObjsSetMotion(2, "上見立ち")
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "おこり目")
	event.ObjsSetMotion(0, "驚くL", 4, -1.0, 1)
	event.ObjsSetMotion(1, "上向くL", 4, -1.0, 1)
	helper_12e48d20(4080170)
	if vm.skipping() then
		return skip(33)
	end
	helper_41c448af(2)
	if vm.skipping() then
		return skip(34)
	end
	event.CmrsReleaseObj()
	event.SetPakuAnim(1, "通常口パク")
	helper_12e48d20(4080180)
	if vm.skipping() then
		return skip(35)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_12e48d20(4080185)
	if vm.skipping() then
		return skip(36)
	end
	helper_474c5bc8(10)
	if vm.skipping() then
		return skip(37)
	end
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "おこり目～おどろき目")
	event.ObjsSetMotion(2, "！！", 2)
	event.ObjsNextMotion(2, "上見立ち")
	helper_cf969bc0(4080190, -1, 0)
	if vm.skipping() then
		return skip(38)
	end
	event.CmrsSetPos(-73.07, -10.65, 595.6)
	event.CmrsSetRef(-87.35, 69.1, 460.59)
	event.SndSePlay(var0, 7)
	event.CharaActive(0, 10)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "おこり目")
	event.ObjsSetMotion(3, "攻撃", 6)
	event.ObjsMotionDelay(3, 30)
	event.ObjsSetMotion(3, "攻撃", 1)
	event.SetPakuAnim(0, "通常口パク")
	event.StreamOpen3(1, 4080200)
	var19 = helper_8893edb6(1)
	if vm.skipping() then
		return skip(39)
	end
	event.SetMesOkuri(0, 0)
	event.MesMake_2(0, 4080200)
	helper_2e8cfc5c(0, -1, 8, 0, 0)
	event.StreamPlay(1)
	helper_474c5bc8(vm.i32(30 - var19))
	if vm.skipping() then
		return skip(40)
	end
	event.CmrsSetPos(-92.53, 6.56, 559.96)
	event.CmrsSetRef(-39.54, 19.62, 593.16)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おこり目パチ")
	event.EohSetTexAnim(0, 1, "大口パク")
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetMotion(0, "走り")
	event.ObjsMove(0, -64.66, 4.79, 541.75, 14, 1)
	helper_474c5bc8(14)
	if vm.skipping() then
		return skip(41)
	end
	helper_be5e42c1(0)
	event.StreamClose(1)
	event.SetMesOkuri(0, 1)
	event.CmrsSetPos(-77.13, 11.5, 549.0)
	event.CmrsSetRef(-117.01, 21.86, 587.27)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.EohSetTexAnim(1, 1, "大口")
	event.ObjsSetMotion(1, "上見びっくり", 6)
	event.ObjsNextMotion(1, "上向くL", 4)
	helper_474c5bc8(10)
	if vm.skipping() then
		return skip(42)
	end
	event.CmrsSetPos(-81.01, 33.49, 535.66)
	event.CmrsSetRef(-86.5, 39.49, 520.89)
	event.SndSePlay(var0, 8)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おこり目パチ")
	event.EohSetTexAnim(0, 1, "大口")
	event.ObjsSetMotion(3, "攻撃2", 6)
	event.ObjsMotionDelay(3, 10)
	event.ObjsSetMotion(3, "攻撃", 1)
	event.ObjsSetPos(0, -8.54, 2.83, 545.17)
	event.ObjsSetRot(0, 0.0, -1.7, 0.0)
	helper_474c5bc8(4)
	if vm.skipping() then
		return skip(43)
	end
	event.CmrsMove2(-81.01, 33.49, 535.66, -67.85, 33.31, 537.58, 12, 0, 0.4)
	helper_474c5bc8(3)
	if vm.skipping() then
		return skip(44)
	end
	event.ObjsSetMotion(0, "タックル", 6, -1.0, 1)
	helper_a88b23ab()
	if vm.skipping() then
		return skip(45)
	end
	event.ObjsSetMotion(3, "攻撃3", 6)
	event.CmrsMove2(-157.5, 18.3, 524.15, -141.51, 23.91, 526.12, 8, 2, 1.0)
	event.CmrsQuake(0.0, 6.0, 0.0, 30)
	helper_474c5bc8(2)
	if vm.skipping() then
		return skip(46)
	end
	if active_chr_no == 0 then
		event.CharaActive(0, 0)
	else
		event.CharaActive(0, 8)
		event.CharaActive(0, 9)
	end
	helper_f48d7d30(4080205, 40)
	if vm.skipping() then
		return skip(47)
	end
	helper_a88b23ab()
	if vm.skipping() then
		return skip(48)
	end
	event.CmrsSetPos(-154.32, 107.18, 768.06)
	event.CmrsSetRef(-95.44, 20.24, 463.89)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おこり目パチ")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	if active_chr_no == 0 then
		event.CharaActive(0)
	else
		event.CharaActive(8)
		event.CharaActive(9)
	end
	event.CharaActive(10)
	event.ObjsSetPos(0, -144.47, 6.3, 567.45)
	event.ObjsSetRot(0, 0.0, 2.02, 0.0)
	event.ObjsSetMotion(0, "立ちあがる", 6, -1.0, 1)
	event.ObjsNextMotion(0, "立ち", 4)
	event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
	event.ObjsSetPos(2, -168.07, 3.48, 508.64)
	event.ObjsSetRot(2, 0.0, 1.22, 0.0)
	event.ObjsResetMotion(2)
	event.ObjsSetMotion(2, "立ちあがる", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.ObjsSetPos(3, -50.57, -15.41, 428.09)
	event.ObjsSetRot(3, 0.0, -0.36, 0.0)
	event.ObjsSetMotion(3, "立ち2", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_12e48d20(4080210)
	if vm.skipping() then
		return skip(49)
	end
	event.ObjsSetMotion(1, "走り")
	event.ObjsMove(1, -111.4, 3.75, 698.18, 40, 1)
	event.ObjsRotation(1, 0.0, 0.14, 0.0, 8)
	helper_474c5bc8(2)
	if vm.skipping() then
		return skip(50)
	end
	event.ObjsSetMotion(0, "走り")
	event.ObjsMove(0, -146.03, 4.47, 681.95, 50, 1)
	event.ObjsRotation(0, 0.0, 0.1, 0.0, 8)
	helper_474c5bc8(8)
	if vm.skipping() then
		return skip(51)
	end
	event.ObjsSetMotion(2, "走り")
	event.ObjsMove(2, -157.24, 4.74, 682.84, 50, 1)
	event.ObjsRotation(2, 0.0, 0.02, 0.0, 8)
	helper_41c448af(2)
	if vm.skipping() then
		return skip(52)
	end
	event.CmrsSetPos(-76.59, 45.52, 642.13)
	event.CmrsSetRef(-76.07, 15.43, 850.71)
	event.FadeOutBgm(60)
	event.ObjsMove(1, -85.95, -25.91, 1068.48, 80, 1)
	event.ObjsMotionDelay(1, 80)
	event.ObjsSetMotion(1, "立ち")
	event.ObjsRotDelay(1, 72)
	event.ObjsRotation(1, 0.0, 3.02, 0.0, 8)
	event.ObjsRotDelay(4, 90)
	event.ObjsRotation2(4, rot_x, rot_y, var4, 40, 0, 0.5)
	event.ObjsPosDelay(5, 130)
	event.ObjsMove2(5, pos_x, pos_y + 80.0, pos_z, 32, 1, 0.5)
	event.ObjsSeDelay(5, 90)
	event.ObjsSePlay(5, var0, 9)
	helper_474c5bc8(4)
	if vm.skipping() then
		return skip(53)
	end
	event.ObjsSetPos(0, -61.85, 3.51, 650.67)
	event.ObjsSetRot(0, 0.0, -0.1, 0.0)
	event.ObjsMove(0, -54.15, -4.35, 911.55, 60, 1)
	event.ObjsMotionDelay(0, 60)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsMotionDelay(0, 5)
	event.ObjsSetMotion(0, "振り向く（右）", 6)
	event.ObjsNextMotion(0, "振り向く（右）L", 4)
	helper_474c5bc8(10)
	if vm.skipping() then
		return skip(54)
	end
	event.ObjsSetPos(2, -87.61, 3.87, 655.48)
	event.ObjsSetRot(2, 0.0, 0.1, 0.0)
	event.ObjsMove(2, -87.84, 2.52, 774.78, 40, 1)
	event.ObjsMotionDelay(2, 40)
	event.ObjsSetMotion(2, "振り向く", 2)
	event.ObjsNextMotion(2, "振り向くL", 4)
	helper_41c448af(2)
	if vm.skipping() then
		return skip(55)
	end
	helper_12e48d20(4080220)
	if vm.skipping() then
		return skip(56)
	end
	event.SetPakuAnim(0, "大口パク")
	helper_12e48d20(4080230)
	if vm.skipping() then
		return skip(57)
	end
	helper_41c448af(5)
	if vm.skipping() then
		return skip(58)
	end
	event.ObjsSetMotion(1, "走り")
	event.ObjsMotionDelay(1, 50)
	event.ObjsSetMotion(1, "立ち")
	event.ObjsMove(1, -19.76, -41.08, 1213.94, 50)
	event.ObjsRotation(1, 0.0, 0.26, 0.0, 6)
	event.ObjsSetMotion(0, "振り向く（右）戻り", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.ObjsMotionDelay(0, 1)
	event.ObjsSetMotion(0, "走り")
	event.ObjsPosDelay(0, 18)
	event.ObjsMove(0, -66.76, -20.35, 1068.29, 40, 1)
	helper_474c5bc8(10)
	if vm.skipping() then
		return skip(59)
	end
	event.ObjsSetMotion(2, "振り向く戻り", 6)
	event.ObjsNextMotion(2, "走り")
	event.ObjsPosDelay(2, 20)
	event.ObjsMove(2, -82.88, -2.14, 896.69, 40, 1)
	helper_474c5bc8(4)
	if vm.skipping() then
		return skip(60)
	end
	helper_474c5bc8(6)
	if vm.skipping() then
		return skip(61)
	end
	event.SetFadeOut(30)
	helper_474c5bc8(30)
	if vm.skipping() then
		return skip(62)
	end
	return part2()
end

return helper_8679ad6e
