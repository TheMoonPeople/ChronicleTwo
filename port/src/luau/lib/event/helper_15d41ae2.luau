--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0958ca60 = require("@lib/event/helper_0958ca60")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_8cd371d7 = require("@lib/event/helper_8cd371d7")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_d3f20302 = require("@lib/event/helper_d3f20302")
local helper_e34416e2 = require("@lib/event/helper_e34416e2")

--- Helper function.
local function helper_15d41ae2()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var5: s32 = 0
	local var6: f32 = 0
	local at: number = 0
	vm.section(function()
		event.SetFlag(600, 1)
		event.Initialize()
		event.SetMesWindowMode(0, 7)
		event.StopBgm(0)
		event.LoadSound(7800)
		var0 = event.SndLoadSound_2(7800) or var0
		event.AssignStack(5)
		event.ClearStack(5)
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		event.SetStatus(1, 0, 256, 1)
		event.ChangeDir("event/e600/e600/")
		event.LoadMes(0, 5, "e600_1.txt")
		if active_chr_no == 0 then
			event.LoadMotion(5, "e600_mints.gltf", "info", 0)
			event.CharaActive(0, 0)
			event.EohSyncChara(0, 0)
			event.ObjsInit(0)
			event.ObjsSyncObj(0, 0)
		end
		if active_chr_no == 1 then
			event.LoadMotion(5, "e600_monica.gltf", "info", 0)
			event.CharaActive(0, 0)
			event.EohSyncChara(1, 0)
			event.ObjsInit(1)
			event.ObjsSyncObj(1, 1)
		end
		event.LoadChara(5, "e600_osmond.gltf", "info", 34)
		event.CharaActive(0, 34)
		event.EohSyncChara(2, 34)
		event.ObjsInit(2)
		event.ObjsSyncObj(2, 2)
		event.LoadChara(5, "e600_hikari.gltf", "info", 35)
		event.CharaActive(1, 35)
		event.LoadChara(5, "e600_nagare.gltf", "info", 36)
		event.CharaActive(1, 36)
		event.EohSyncChara(6, 36)
		event.ObjsInit(6)
		event.ObjsSyncObj(6, 6)
		event.ChangeDir("")
		if active_chr_no == 1 then
			event.LoadChara(5, "chara/c01_base.gltf", "info", 32)
			event.LoadEquip(5, 0, 4, "info", 32)
			event.LoadEquip(5, 0, 3, "info", 32)
			event.LoadEquip(5, 0, 2, "info", 32, 33)
			event.LoadMotion(5, "event/e600/e600/e600_mints.gltf", "info", 32)
			event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 32)
			event.EohSyncChara(0, 32)
			event.ObjsInit(0)
			event.ObjsSyncObj(0, 0)
			event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.LoadChara(5, "chara/c02_base.gltf", "info", 32)
			event.LoadEquip(5, 1, 4, "info", 32)
			event.LoadEquip(5, 1, 3, "info", 32)
			event.LoadEquip(5, 1, 2, "info", 32, 33)
			event.LoadMotion(5, "event/e600/e600/e600_monica.gltf", "info", 32)
			event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 32)
			event.EohSyncChara(1, 32)
			event.ObjsInit(1)
			event.ObjsSyncObj(1, 1)
			event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.CharaActive(0, 32)
		event.CharaActive(0, 33)
		event.EohSyncObj_2(3, "p01_train01")
		event.ObjsInit(3)
		event.ObjsSyncObj(3, 3)
		event.EohSyncObj_3(4, "p01_train01", "s3601_13-m1")
		event.ObjsInit(4)
		event.ObjsSyncObj(4, 4)
		event.EohSyncObj_3(5, "p01_train01", "s3601_15-m2")
		event.ObjsInit(5)
		event.ObjsSyncObj(5, 5)
		event.EohSyncObj_2(7, "p01_shadow-0")
		event.EohSetPos(0, 593.01, 30.8, 3553.84)
		event.EohSetRot(0, 0.0, 3.14, 0.0)
		event.EohSetMotion(0, "立ち", 4)
		event.EohSetFootSoundId(0, 16)
		event.EohSetTexAnim(0, 0)
		event.EohSetTexAnim(0, 1, "おこり顔")
		event.EohSetTexAnim(0, 1, "おこり目パチ")
		event.EohSetPos(1, 583.22, 30.8, 3557.92)
		event.EohSetRot(1, 0.0, 3.14, 0.0)
		event.EohSetMotion(1, "立ち", 4)
		event.EohSetFootSoundId(1, 16)
		event.EohSetTexAnim(1, 0)
		event.EohSetTexAnim(1, 1, "おこり顔")
		event.EohSetTexAnim(1, 1, "おこり目パチ")
		event.EohSetPos(2, 588.09, 30.8, 3562.57)
		event.EohSetRot(2, 0.0, 3.14, 0.0)
		event.EohSetMotion(2, "立ち", 4)
		event.EohSetFootSoundId(2, 16)
		event.EohSetPos(3, -6000.0, 2400.0, 1600.0)
		event.EohSetRot(3, 0.2, 1.2, 0.0)
		event.EohSetRot(4, 0.0, 0.0, 0.0)
		event.EohSetRot(5, 0.0, 0.0, 0.0)
		event.EohSetShow(7, 0)
		event.EohSetPos(6, -6000.0, 2480.0, 1600.0)
		event.EohSetRot(6, 0.2, 1.2, 0.0)
		event.EohSetMotion(6, "ループ", 4)
		event.SetCharaPos(35, -6000.0, 2400.0, 1600.0)
		event.InitDramaScene()
		event.CmrsInit()
		event.CmrsSetPos(1067.88, 491.78, 4477.15)
		event.CmrsSetRef(432.94, 580.78, 4182.04)
		event.CmrsMove2(1067.88, 491.78, 4477.15, 858.72, 267.72, 3985.84, 90, 2, 1.0)
		event.SndSePlay(var0, 2)
		event.SndSePlay(var0, 3)
		event.SetFadeIn(30)
		event.ObjsRotation2(3, 0.0, 1.57, 0.0, 60, 2, 1.0)
		event.ObjsRotation2(6, 0.0, 1.57, 0.0, 60, 2, 1.0)
		var5 = 0
		while var5 < 90 do
			if var5 == 20 then
				event.SetCharaShow(35, 0, 1, 0.033333335)
				event.SetCharaShow(36, 0, 1, 0.033333335)
			end
			at = 1
			vm.wait(1)
			do
				local out1, out2, out3 = event.EohGetPos(3)
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			pos_x = vm.f32(pos_x + vm.f32(vm.f32(790.0 - pos_x) / 24.0))
			pos_y = vm.f32(pos_y + vm.f32(vm.f32(0.0 - pos_y) / 16.0))
			pos_z = vm.f32(pos_z + vm.f32(vm.f32(3600.0 - pos_z) / 16.0))
			event.EohSetPos(3, pos_x, pos_y, pos_z)
			event.EohSetPos(6, pos_x, pos_y + 80.0, pos_z)
			var5 = var5 + 1
		end
		event.ObjsMove2(3, 790.0, 0.0, 3600.0, 30, 2, 1.0)
		event.ObjsRotation(3, 0.0, 1.57, 0.0, 30)
		event.ObjsMove2(6, 790.0, 0.0, 3680.0, 30, 2, 1.0)
		event.ObjsRotation(6, 0.0, 1.57, 0.0, 30)
		var6 = 2.0
		var5 = 0
		while var5 < 30 do
			do
				local out1, out2, out3 = event.EohGetPos(3)
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			if vm.imod(var5, 2) == 0 then
				pos_y = vm.f32(pos_y + var6)
			else
				pos_y = vm.f32(pos_y - var6)
			end
			var6 = vm.f32(var6 - vm.f32(var6 / 30.0))
			event.EohSetPos(3, pos_x, pos_y, pos_z)
			var5 = var5 + 1
			at = 2
			vm.wait(2)
		end
		at = 3
		helper_0958ca60(3)
		at = 4
		helper_25abe6d2(20)
		event.CmrsSetPos(407.12, 258.94, 3255.47)
		event.CmrsSetRef(609.92, 112.52, 3513.32)
		event.ObjsSetPos(3, 790.0, 0.0, 3600.0)
		event.ObjsSetRot(3, 0.0, 1.57, 0.0)
		event.CharaActive(0)
		event.CharaActive(32)
		event.CharaActive(33)
		event.CharaActive(34)
		at = 5
		helper_25abe6d2(10)
		event.SndSePlay(var0, 4)
		event.ObjsRotation2(4, 0.0, 0.0, 1.6, 30, 0, 1.0)
		event.ObjsRotation2(5, 0.0, 0.0, 1.6, 30, 0, 1.0)
		at = 6
		helper_25abe6d2(60)
		event.ObjsJump(0, 616.43, 0.0, 3519.44, -0.2, 20)
		event.ObjsSetMotion(0, "走り")
		event.ObjsMotionDelay(0, 4)
		event.ObjsSetMotion(0, "着地", 1)
		event.ObjsMotionDelay(0, 10)
		event.ObjsSetMotion(0, "着地", 2)
		event.ObjsNextMotion(0, "立ち", 4)
		at = 7
		helper_25abe6d2(10)
		event.ObjsJump(1, 590.55, 0.0, 3527.36, -0.2, 20)
		event.ObjsSetMotion(1, "走り")
		event.ObjsMotionDelay(1, 4)
		event.ObjsSetMotion(1, "着地", 1)
		event.ObjsMotionDelay(1, 10)
		event.ObjsSetMotion(1, "着地", 2)
		event.ObjsNextMotion(1, "立ち", 4)
		at = 8
		helper_0958ca60(1)
		event.CmrsSetPos(734.79, 34.32, 3415.62)
		event.CmrsSetRef(645.05, 7.39, 3483.16)
		event.ObjsSetPos(0, 678.03, 0.0, 3463.04)
		event.ObjsSetRot(0, 0.0, 2.18, 0.0)
		event.ObjsSetMotion(0, "キョロキョロ歩き", 4, -1, 1)
		event.ObjsMove(0, 732.73, 0.0, 3421.88, 90)
		event.ObjsResetDaPosition(0)
		event.ObjsMotionDelay(0, 90)
		event.ObjsSetMotion(0, "立ち", 4)
		event.ObjsSetPos(1, 623.2, 0.0, 3468.36)
		event.ObjsSetRot(1, 0.0, 2.9, 0.0)
		event.ObjsResetDaPosition(1)
		event.ObjsSetPos(2, 604.19, 0.0, 3501.3)
		event.ObjsSetRot(2, 0.0, 3.14, 0.0)
		event.SetPakuAnim(0, "通常口パク")
		at = 9
		helper_e34416e2(6000370)
		event.SetPakuAnim(1, "通常口パク")
		at = 10
		helper_e34416e2(6000380)
		at = 11
		helper_0958ca60(0)
		event.CmrsSetPos(834.25, 32.04, 3503.77)
		event.CmrsSetRef(728.22, 120.07, 3124.24)
		event.ObjsSetPos(0, 688.8, 11.3, 3250.37)
		event.ObjsSetRot(0, 0.0, -2.26, 0.0)
		event.ObjsSetMotion(0, "指さす", 4, -1.0, 1)
		event.SetPakuAnim(0, "通常口パク")
		at = 12
		helper_e34416e2(6000390)
		event.CmrsSetPos(616.62, 51.57, 3428.73)
		event.CmrsSetRef(613.93, 8.94, 3476.66)
		event.EohSetTexAnim(1, 0)
		event.EohSetTexAnim(1, 1, "こまり顔")
		event.EohSetTexAnim(1, 1, "こまり目パチ")
		event.ObjsSetMotion(1, "上向くL", 4, -1, 1)
		event.ObjsSetRot(1, 0.0, -2.9, 0.0)
		event.ObjsResetDaPosition(1)
		event.ObjsSetMotion(2, "歩き（上見）")
		event.ObjsMove(2, 603.8, 0.0, 3472.38, 60)
		event.ObjsMotionDelay(2, 60)
		event.ObjsSetMotion(2, "立ち（上見）")
		event.SetPakuAnim(1, "通常口パク")
		at = 13
		helper_e34416e2(6000400)
		at = 14
		helper_e34416e2(6000410)
		event.CmrsSetPos(0.0, 995.95, 3461.49)
		event.CmrsSetRef(0.0, 846.5, 1987.55)
		event.CmrsMove2(0.0, 25.08, 3461.49, 0.0, 392.85, 1987.55, 120, 0, 1.0)
		event.EohSetFootSoundId(0, 2)
		event.EohSetFootSoundId(1, 2)
		event.EohSetFootSoundId(2, 2)
		event.ObjsSetPos(0, -12.0, 0.0, 3300.0)
		event.ObjsSetRot(0, 0.0, 3.14, 0.0)
		event.ObjsSetPos(1, 12.0, 0.0, 3300.0)
		event.ObjsSetRot(1, 0.0, 3.14, 0.0)
		event.ObjsSetPos(2, 0.0, 0.0, 3320.0)
		event.ObjsSetRot(2, 0.0, 3.14, 0.0)
		at = 15
		helper_25abe6d2(200)
		event.ObjsMove(0, -12.0, 14.0, 3000.0, 160, 1)
		event.ObjsSetMotion(0, "歩き")
		event.ObjsMove(1, 12.0, 14.0, 3000.0, 160, 1)
		event.ObjsSetMotion(1, "歩き")
		event.ObjsMove(2, 0.0, 9.0, 3020.0, 160, 1)
		event.ObjsSetMotion(2, "歩き")
		at = 16
		helper_0958ca60(0)
		event.CmrsSetPos(35.49, 35.66, 2985.73)
		event.CmrsSetRef(5.9, 35.78, 3001.23)
		event.EohSetTexAnim(1, 0)
		event.EohSetTexAnim(1, 1, "おこり顔")
		event.EohSetTexAnim(1, 1, "おこり目パチ")
		event.ObjsSetMotion(0, "上向くL", 4, -1, 1)
		event.ObjsSetMotion(1, "上向くL", 4, -1, 1)
		event.ObjsSetMotion(2, "立ち（上見）", 4)
		event.SetPakuAnim(1, "通常口パク")
		at = 17
		helper_e34416e2(6000420)
		event.CmrsSetPos(-25.58, 61.54, 2959.33)
		event.CmrsSetRef(-12.23, 37.86, 2998.16)
		event.CmrsMove2(-18.54, 50.73, 2979.81, -12.23, 37.86, 2998.16, 60, 2, 1.0)
		event.SetPakuAnim(0, "通常口パク")
		at = 18
		helper_e34416e2(6000430)
		event.SetPakuAnim(0, "通常口パク")
		at = 19
		helper_e34416e2(6000435)
		event.CmrsSetPos(0.0, 6.31, 3126.74)
		event.CmrsSetRef(0.0, 59.43, 2999.73)
		event.SetPakuAnim(1, "通常口パク")
		at = 20
		helper_e34416e2(6000440)
		event.ObjsSetMotion(0, "振り返る", 6)
		event.ObjsNextMotion(0, "振り返るL", 4)
		event.ObjsSeDelay(0, 10)
		event.ObjsSePlay(0, var0, 5)
		event.ObjsMotionDelay(1, 4)
		event.ObjsSetMotion(1, "上見から振り返り", 6)
		event.ObjsNextMotion(1, "上見から振り返りL", 4)
		at = 21
		helper_e34416e2(6000450)
		event.SetPakuAnim(0, "通常口パク")
		at = 22
		helper_e34416e2(6000460)
		event.SetFadeOut(30)
		at = 23
		helper_25abe6d2(30)
	end, function(received: { any }): boolean
		if at <= 1 then
			pos_x = vm.f32(pos_x + vm.f32(vm.f32(790.0 - pos_x) / 24.0))
			pos_y = vm.f32(pos_y + vm.f32(vm.f32(0.0 - pos_y) / 16.0))
			pos_z = vm.f32(pos_z + vm.f32(vm.f32(3600.0 - pos_z) / 16.0))
			local _ = var5 < 90
			local _ = var5 == 20
			var5 = var5 + 1
			var6 = 2.0
			var5 = 0
			pos_y = vm.f32(pos_y + var6)
			pos_y = vm.f32(pos_y - var6)
			var6 = vm.f32(var6 - vm.f32(var6 / 30.0))
			local _ = var5 < 30
			local _ = vm.imod(var5, 2) == 0
			var5 = var5 + 1
		end
		if at <= 2 then
			helper_238b5abc(3)
		end
		if at <= 3 then
			helper_d3f20302(20)
		end
		if at <= 4 then
			helper_d3f20302(10)
		end
		if at <= 5 then
			helper_d3f20302(60)
		end
		if at <= 6 then
			helper_d3f20302(10)
		end
		if at <= 7 then
			helper_238b5abc(1)
		end
		if at <= 8 then
			helper_8cd371d7(6000370)
		end
		if at <= 9 then
			helper_8cd371d7(6000380)
		end
		if at <= 10 then
			helper_238b5abc(0)
		end
		if at <= 11 then
			helper_8cd371d7(6000390)
		end
		if at <= 12 then
			helper_8cd371d7(6000400)
		end
		if at <= 13 then
			helper_8cd371d7(6000410)
		end
		if at <= 14 then
			helper_d3f20302(200)
		end
		if at <= 15 then
			helper_238b5abc(0)
		end
		if at <= 16 then
			helper_8cd371d7(6000420)
		end
		if at <= 17 then
			helper_8cd371d7(6000430)
		end
		if at <= 18 then
			helper_8cd371d7(6000435)
		end
		if at <= 19 then
			helper_8cd371d7(6000440)
		end
		if at <= 20 then
			helper_8cd371d7(6000450)
		end
		if at <= 21 then
			helper_8cd371d7(6000460)
		end
		if at <= 22 then
			helper_d3f20302(30)
		end
		return true
	end)
	event.CancelDramaScene()
	event.EohSetShow(7, 1)
	event.CharaActive(0)
	event.CharaActive(32)
	event.CharaActive(33)
	event.SetStatus(1, 0, 256, 0)
	event.EohSetFootSoundId(0, 0)
	event.EohSetFootSoundId(1, 0)
	event.EohSetPos(3, 790.0, 0.0, 3600.0)
	event.EohSetRot(3, 0.0, 1.57, 0.0)
	event.EohSetRot(4, 0.0, 0.0, 0.0)
	event.EohSetRot(5, 0.0, 0.0, 0.0)
	event.CharaActive(0)
	event.DelExtMotion(0)
	event.DeleteChara(32)
	event.DeleteChara(33)
	event.DeleteChara(34)
	event.DeleteChara(35)
	event.DeleteChara(36)
	event.LoadMes(0, -1)
	helper_9dafbc83(0.0, vm.f32(3.9), 3200.0, vm.f32(3.14))
	event.ResetCamera(1, 3.14, 10)
	event.SetFadeIn(30)
end

return helper_15d41ae2
