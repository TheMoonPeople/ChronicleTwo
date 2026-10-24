--!strict
-- map/f/f03/i03/f03i0302_3.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_635ee3fd = require("@lib/event/helper_635ee3fd")
local helper_8508907e = require("@lib/event/helper_8508907e")
local helper_ac6949ab = require("@lib/event/helper_ac6949ab")
local helper_b578b747 = require("@lib/event/helper_b578b747")
local helper_c3ce9c48 = require("@lib/event/helper_c3ce9c48")
local helper_e2d04ed9 = require("@lib/event/helper_e2d04ed9")
local helper_e7ba8bf4 = require("@lib/event/helper_e7ba8bf4")
local helper_e7da2113 = require("@lib/event/helper_e7da2113")
local helper_ed0a80b8 = require("@lib/event/helper_ed0a80b8")
local helper_f9fe2856 = require("@lib/event/helper_f9fe2856")
local helper_fc5f5017 = require("@lib/event/helper_fc5f5017")

--- Helper function.
local function helper_13ec8()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	local block: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 89 then
			if at <= 1 then
				helper_ed0a80b8(30)
			end
			if at <= 2 then
				helper_ed0a80b8(30)
			end
			if at <= 3 then
				helper_f9fe2856()
			end
			if at <= 4 then
				helper_ed0a80b8(60)
			end
			if at <= 5 then
				helper_e2d04ed9(2)
			end
			if at <= 6 then
				helper_c3ce9c48(4280005)
			end
			if at <= 7 then
				helper_e2d04ed9(2)
			end
			if at <= 8 then
				helper_ed0a80b8(10)
			end
			if at <= 9 then
				helper_c3ce9c48(4280010)
			end
			if at <= 10 then
				helper_e2d04ed9(2)
			end
			if at <= 11 then
				helper_c3ce9c48(4280020)
			end
			if at <= 12 then
				helper_e2d04ed9(2)
			end
			if at <= 13 then
				helper_ed0a80b8(6)
			end
			if at <= 14 then
				helper_c3ce9c48(4280030)
			end
			if at <= 15 then
				helper_e2d04ed9(2)
			end
			if at <= 16 then
				helper_e2d04ed9(1)
			end
			if at <= 17 then
				helper_c3ce9c48(4280040)
			end
			if at <= 18 then
				helper_c3ce9c48(4280050)
			end
			if at <= 19 then
				helper_e2d04ed9(2)
			end
			if at <= 20 then
				helper_c3ce9c48(4280055)
			end
			if at <= 21 then
				helper_e2d04ed9(2)
			end
			if at <= 22 then
				helper_c3ce9c48(4280060)
			end
			if at <= 23 then
				helper_e2d04ed9(0)
			end
			if at <= 24 then
				helper_c3ce9c48(4280070)
			end
			if at <= 25 then
				helper_c3ce9c48(4280080)
			end
			if at <= 26 then
				helper_c3ce9c48(4280085)
			end
			if at <= 27 then
				helper_e2d04ed9(2)
			end
			if at <= 28 then
				helper_c3ce9c48(4280090)
			end
			if at <= 29 then
				helper_e2d04ed9(2)
			end
			if at <= 30 then
				helper_c3ce9c48(4280100)
			end
			if at <= 31 then
				helper_e2d04ed9(0)
			end
			if at <= 32 then
				helper_c3ce9c48(4280110)
			end
			if at <= 33 then
				helper_e2d04ed9(2)
			end
			if at <= 34 then
				helper_c3ce9c48(4280120)
			end
			if at <= 35 then
				helper_c3ce9c48(4280125)
			end
			if at <= 36 then
				helper_e2d04ed9(0)
			end
			if at <= 37 then
				helper_c3ce9c48(4280130)
			end
			if at <= 38 then
				helper_c3ce9c48(4280135)
			end
			if at <= 39 then
				helper_e2d04ed9(2)
			end
			if at <= 40 then
				helper_c3ce9c48(4280140)
			end
			if at <= 41 then
				helper_c3ce9c48(4280150)
			end
			if at <= 42 then
				helper_e2d04ed9(4)
			end
			if at <= 43 then
				helper_c3ce9c48(4280160)
			end
			if at <= 44 then
				helper_c3ce9c48(4280170)
			end
			if at <= 45 then
				helper_e2d04ed9(5)
			end
			if at <= 46 then
				helper_c3ce9c48(4280180)
			end
			if at <= 47 then
				helper_c3ce9c48(4280190)
			end
			if at <= 48 then
				helper_c3ce9c48(4280200)
			end
			if at <= 49 then
				helper_e2d04ed9(2)
			end
			if at <= 50 then
				helper_c3ce9c48(4280210)
			end
			if at <= 51 then
				helper_e2d04ed9(2)
			end
			if at <= 52 then
				helper_ed0a80b8(8)
			end
			if at <= 53 then
				helper_c3ce9c48(4280220)
			end
			if at <= 54 then
				helper_e2d04ed9(2)
			end
			if at <= 55 then
				helper_c3ce9c48(4280230)
			end
			if at <= 56 then
				helper_e2d04ed9(3)
			end
			if at <= 57 then
				helper_c3ce9c48(4280240)
			end
			if at <= 58 then
				helper_e2d04ed9(2)
			end
			if at <= 59 then
				helper_c3ce9c48(4280250)
			end
			if at <= 60 then
				helper_e2d04ed9(3)
			end
			if at <= 61 then
				helper_e2d04ed9(3)
			end
			if at <= 62 then
				helper_ed0a80b8(30)
			end
			if at <= 63 then
				helper_e2d04ed9(3)
			end
			if at <= 64 then
				helper_ed0a80b8(6)
			end
			if at <= 65 then
				helper_e2d04ed9(3)
			end
			if at <= 66 then
				helper_c3ce9c48(4280260)
			end
			if at <= 67 then
				helper_e2d04ed9(3)
			end
			if at <= 68 then
				helper_e2d04ed9(2)
			end
			if at <= 69 then
				helper_ed0a80b8(4)
			end
			if at <= 70 then
				helper_c3ce9c48(4280270)
			end
			if at <= 71 then
				helper_e2d04ed9(0)
			end
			if at <= 72 then
				helper_ed0a80b8(10)
			end
			if at <= 73 then
				helper_ed0a80b8(2)
			end
			if at <= 74 then
				helper_ed0a80b8(120)
			end
			if at <= 75 then
				helper_8508907e(373, 1)
			end
			if at <= 76 then
				helper_c3ce9c48(4280280)
			end
			if at <= 77 then
				helper_e2d04ed9(0)
			end
			if at <= 78 then
				helper_c3ce9c48(4280290)
			end
			if at <= 79 then
				helper_c3ce9c48(4280300)
			end
			if at <= 80 then
				helper_e2d04ed9(2)
			end
			if at <= 81 then
				helper_c3ce9c48(4280310)
			end
			if at <= 82 then
				helper_e2d04ed9(2)
			end
			if at <= 83 then
				helper_c3ce9c48(4280320)
			end
			if at <= 84 then
				helper_e2d04ed9(0)
			end
			if at <= 85 then
				helper_c3ce9c48(4280330)
			end
			if at <= 86 then
				helper_c3ce9c48(4280340)
			end
			if at <= 87 then
				helper_e2d04ed9(2)
			end
			if at <= 88 then
				helper_ed0a80b8(30)
			end
			if vm.skip_end() then
				return skip(90)
			end
			return part2()
		end
		if at <= 90 then
			helper_e7ba8bf4(0)
		end
		helper_ac6949ab(vm.f32(136.9), 0.0, vm.f32(92.6), -1.75)
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var1, 0)
		event.PlayBgm(0)
		event.CharaActive(0)
		event.CharaActive(32)
		event.CharaActive(33)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.SpriteSetDraw(0, 0)
		event.SpriteSetDraw(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(32)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.DeleteChara(36)
		event.DeleteChara(35)
		event.DeleteChara(37)
		event.DeleteChara(38)
		event.DelImg(0)
		event.LoadMes(0, -1)
		helper_e7ba8bf4(0)
		if vm.skipping() then
			return skip(91)
		end
		event.CharaActive(var0)
		helper_ac6949ab(vm.f32(136.9), 0.0, vm.f32(92.6), -1.75)
		event.ResetCamera(1, 3.14, 10)
		event.SetFadeIn(30)
	end
	event.SetFlag(428, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	var0 = event.SearchCharaNo(303) or var0
	event.CharaActive(0, var0)
	event.StopBgm(0)
	helper_ed0a80b8(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(54)
	event.PlayBgm(0)
	event.LoadSound(4506)
	var1 = event.SndLoadSound(8, "snd2/sp/sp_006.sound.json") or var1
	var2 = event.SndLoadSound(4506) or var2
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e400/e428/")
	event.LoadMes(0, 5, "e428_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e428_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e428_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e428_chap.gltf", "info", 34)
	event.CharaActive(34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e428_lunaken.gltf", "info", 35)
	event.CharaActive(35)
	event.EohSyncChara(3, 35)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.LoadChara(5, "e428_honyaku.gltf", "info", 36)
	event.CharaActive(0, 36)
	event.SetReference(35, "h", 36)
	event.LoadChara(5, "e434_honyaku_y.gltf", "info", 37)
	event.CharaActive(0, 37)
	block = event.LoadImg_4(5, "e428_1.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e42801", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 448)
	event.SpriteSetPutsize(0, 512, 448)
	event.SpriteSetPos(0, 256, 224)
	event.SpriteSetDraw(0, 1)
	event.EohSyncSprite(4, 0)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.SpriteInit(1)
	event.SpriteSetType(1, 0)
	event.SpriteSetTexture(1, "e42802", block)
	event.SpriteSetColor(1, 128, 128, 128, 0)
	event.SpriteSetUvsize(1, 0, 0, 512, 448)
	event.SpriteSetPutsize(1, 512, 448)
	event.SpriteSetPos(1, 256, 224)
	event.SpriteSetDraw(1, 1)
	event.EohSyncSprite(5, 1)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.ChangeDir("")
	event.LoadChara(5, "event/itemget_ev/itemget_ev.gltf", "info", 38)
	event.CharaActive(0, 38)
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 32)
		event.LoadEquip(5, 0, 4, "info", 32)
		event.LoadEquip(5, 0, 3, "info", 32)
		event.LoadEquip(5, 0, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e400/e428/e428_mints.gltf", "info", 32)
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
		event.LoadMotion(5, "event/e400/e428/e428_monica.gltf", "info", 32)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 32)
		event.EohSyncChara(1, 32)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(32)
	event.CharaActive(33)
	if active_chr_no == 0 then
		event.SetReference(0, "item", 37)
	else
		event.SetReference(32, "item", 37)
	end
	event.EohSetPos(0, 20.0, 69.1, -210.0)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 6)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetPos(1, 0.0, 69.1, -210.0)
	event.EohSetRot(1, 0.0, 0.0, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetFootSoundId(1, 6)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.EohSetPos(2, -208.12, 20.0, 88.84)
	event.EohSetMotion(2, "立ち", 4)
	event.EohSetFootSoundId(2, 6)
	event.EohSetPos(3, -55.15, 1.09, 220.25)
	event.EohSetRot(3, 0.0, 1.08, 0.0)
	event.EohSetMotion(3, "座る", 4)
	event.EohSetFootSoundId(3, 6)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(11.21, 73.31, -143.14)
	event.CmrsSetRef(10.97, 89.26, -210.05)
	event.SetFadeIn(30)
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(2)
	end
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目～おどろき目")
	event.EohSetTexAnim(0, 1, "口とじ～半口")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目～おどろき目")
	event.EohSetTexAnim(1, 1, "口とじ～半口")
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsSetPos(-2.42, 119.18, -230.92)
	event.CmrsSetRef(-49.1, 99.28, -160.19)
	event.CmrsMove2(-2.42, 119.18, -230.92, 29.39, 99.28, -151.85, 60, 0, 1.0)
	helper_f9fe2856()
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(333.36, 139.53, -117.52)
	event.CmrsSetRef(202.7, 64.84, 9.49)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.ObjsSetPos(1, 263.03, 26.3, 11.44)
	event.ObjsSetMotion(1, "歩き", 4, -1.0, 1)
	event.ObjsMotionDelay(1, 160)
	event.ObjsSetMotion(1, "立ち")
	event.ObjsInitPas(1)
	event.ObjsSetPasFrm(1, 160)
	event.ObjsAddPas(1, 263.03, 29.31, 11.44)
	event.ObjsAddPas(1, 239.48, 10.51, 56.28)
	event.ObjsAddPas(1, 190.07, -0.0, 93.17)
	event.ObjsAddPas(1, 133.12, -0.0, 104.78)
	event.ObjsStartPas(1, 1)
	event.ObjsSetPos(0, 280.36, 37.89, -11.47)
	event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
	event.ObjsMotionDelay(0, 180)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 180)
	event.ObjsAddPas(0, 280.36, 40.89, -11.47)
	event.ObjsAddPas(0, 267.35, 24.37, 25.15)
	event.ObjsAddPas(0, 235.12, 10.0, 77.4)
	event.ObjsAddPas(0, 191.58, -0.0, 108.67)
	event.ObjsAddPas(0, 159.8, -0.0, 123.59)
	event.ObjsAddPas(0, 129.32, -0.0, 127.59)
	event.ObjsStartPas(0, 1)
	helper_ed0a80b8(60)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(2, "歩き", 4)
	event.ObjsInitPas(2)
	event.ObjsSetPasFrm(2, 140)
	event.ObjsAddPas(2, -208.12, 20.0, 88.84)
	event.ObjsAddPas(2, -177.39, 16.54, 118.19)
	event.ObjsAddPas(2, -136.65, 4.85, 136.99)
	event.ObjsAddPas(2, -106.68, -0.0, 149.15)
	event.ObjsAddPas(2, -77.88, -0.0, 145.09)
	event.ObjsStartPas(2, 1)
	helper_e2d04ed9(2)
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsSetPos(140.48, 39.87, 119.98)
	event.CmrsSetRef(53.59, 6.42, 120.03)
	event.ObjsSetPos(0, 100.0, 0.0, 130.0)
	event.ObjsSetRot(0, 0.0, -1.69, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetPos(1, 100.0, 0.0, 110.0)
	event.ObjsSetRot(1, 0.0, -1.45, 0.0)
	event.ObjsResetDaPosition(1)
	event.ObjsSetPos(2, 0.0, 0.0, 120.0)
	event.ObjsSetRot(2, 0.0, 1.57, 0.0)
	event.ObjsMove(2, 60.0, 0.0, 120.0, 90)
	event.ObjsSetMotion(2, "歩き（手振り）", 4)
	event.ObjsNextMotion(2, "歩き", 4)
	event.ObjsMotionDelay(2, 23)
	event.ObjsSetMotion(2, "立ち")
	event.SetPakuAnim(2, "わらい口パク")
	helper_c3ce9c48(4280005)
	if vm.skipping() then
		return skip(7)
	end
	helper_e2d04ed9(2)
	if vm.skipping() then
		return skip(8)
	end
	helper_ed0a80b8(10)
	if vm.skipping() then
		return skip(9)
	end
	event.CmrsSetPos(88.52, 13.64, 103.92)
	event.CmrsSetRef(61.13, 17.27, 120.58)
	event.ObjsSetMotion(2, "会話", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.SetPakuAnim(2, "わらい口パク")
	helper_c3ce9c48(4280010)
	if vm.skipping() then
		return skip(10)
	end
	helper_e2d04ed9(2)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(25.57, 38.04, 119.09)
	event.CmrsSetRef(88.34, 14.0, 120.01)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おどろき顔")
	event.EohSetTexAnim(1, 1, "おどろき目パチ")
	event.SetPakuAnim(1, "通常口パク")
	helper_c3ce9c48(4280020)
	if vm.skipping() then
		return skip(12)
	end
	event.ObjsMove(2, 87.17, 0.0, 113.28, 40)
	event.ObjsRotation(2, 0.0, 1.69, 0.0, 10)
	event.ObjsSetMotion(2, "歩き")
	event.ObjsMotionDelay(2, 40)
	event.ObjsSetMotion(2, "立ち")
	helper_e2d04ed9(2)
	if vm.skipping() then
		return skip(13)
	end
	helper_ed0a80b8(6)
	if vm.skipping() then
		return skip(14)
	end
	event.CmrsSetPos(65.28, 12.75, 87.66)
	event.CmrsSetRef(91.29, 17.73, 110.53)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetTexAnim(0, 1, "口とじ～半口")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おどろき顔")
	event.EohSetTexAnim(1, 1, "おどろき目～通常目")
	event.EohSetTexAnim(1, 1, "口あけ～口とじ")
	event.SndSePlay(var2, 2)
	event.ObjsSetMotion(2, "指すin", 6)
	event.ObjsNextMotion(2, "指す（会話）", 6)
	event.ObjsNextMotion(2, "指すループ", 4)
	event.ObjsSetMotion(1, "のけぞり", 6)
	event.ObjsNextMotion(1, "のけぞりL", 4)
	event.SetPakuAnim(2, "通常口パク")
	helper_c3ce9c48(4280030)
	if vm.skipping() then
		return skip(15)
	end
	helper_e2d04ed9(2)
	if vm.skipping() then
		return skip(16)
	end
	helper_e2d04ed9(1)
	if vm.skipping() then
		return skip(17)
	end
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "無表情")
	event.EohSetTexAnim(1, 1, "まばたき目パチ")
	event.SetPakuAnim(1, "通常口パク")
	helper_c3ce9c48(4280040)
	if vm.skipping() then
		return skip(18)
	end
	event.CmrsSetPos(147.39, 61.78, 168.46)
	event.CmrsSetRef(74.68, 8.86, 114.05)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
	event.ObjsMove(2, 60.0, 0.0, 120.0, 40)
	event.ObjsRotation(2, 0.0, -1.31, 0.0, 10)
	event.ObjsRotDelay(2, 20)
	event.ObjsRotation(2, 0.0, -1.6, 0.0, 10)
	event.ObjsSetMotion(2, "立ち（後手）", 4)
	event.ObjsNormalDrive(2)
	event.ObjsSetMotion(2, "歩き（後手）")
	event.ObjsMotionDelay(2, 40)
	event.ObjsSetMotion(2, "立ち（後手）")
	event.SetPakuAnim(2, "通常口パク")
	helper_c3ce9c48(4280050)
	if vm.skipping() then
		return skip(19)
	end
	helper_e2d04ed9(2)
	if vm.skipping() then
		return skip(20)
	end
	event.CmrsSetPos(88.52, 13.64, 103.92)
	event.CmrsSetRef(61.13, 17.27, 120.58)
	event.SndSePlay(var2, 3)
	event.ObjsRotation(2, 0.0, 1.57, 0.0, 20)
	event.ObjsSetMotion(2, "振り向く", 6)
	event.ObjsNextMotion(2, "立ち（後手）", 4)
	event.SetPakuAnim(2, "通常口パク")
	helper_c3ce9c48(4280055)
	if vm.skipping() then
		return skip(21)
	end
	helper_e2d04ed9(2)
	if vm.skipping() then
		return skip(22)
	end
	event.CmrsSetPos(148.59, 59.87, 169.61)
	event.CmrsSetRef(73.77, 3.31, 110.58)
	event.ObjsSetMotion(2, "立ち", 4)
	event.ObjsSetMotion(0, "会話", 2)
	event.ObjsNextMotion(0, "立ち", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_c3ce9c48(4280060)
	if vm.skipping() then
		return skip(23)
	end
	helper_e2d04ed9(0)
	if vm.skipping() then
		return skip(24)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_c3ce9c48(4280070)
	if vm.skipping() then
		return skip(25)
	end
	event.CmrsSetPos(138.73, 11.1, 119.37)
	event.CmrsSetRef(58.75, 24.2, 119.86)
	event.ObjsSetMotion(2, "会話", 2)
	event.ObjsNextMotion(2, "立ち", 4)
	event.SetPakuAnim(2, "通常口パク")
	helper_c3ce9c48(4280080)
	if vm.skipping() then
		return skip(26)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_c3ce9c48(4280085)
	if vm.skipping() then
		return skip(27)
	end
	helper_e2d04ed9(2)
	if vm.skipping() then
		return skip(28)
	end
	event.CmrsSetPos(92.81, 38.23, 102.21)
	event.CmrsSetRef(58.75, 11.98, 119.86)
	event.ObjsSetMotion(2, "会話", 2)
	event.ObjsNextMotion(2, "立ち", 4)
	event.SetPakuAnim(2, "通常口パク")
	helper_c3ce9c48(4280090)
	if vm.skipping() then
		return skip(29)
	end
	helper_e2d04ed9(2)
	if vm.skipping() then
		return skip(30)
	end
	event.CmrsSetPos(21.41, 40.91, 119.91)
	event.CmrsSetRef(94.63, 8.7, 119.61)
	event.ObjsSetMotion(0, "会話", 2)
	event.ObjsNextMotion(0, "立ち", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_c3ce9c48(4280100)
	if vm.skipping() then
		return skip(31)
	end
	helper_e2d04ed9(0)
	if vm.skipping() then
		return skip(32)
	end
	event.ObjsSetMotion(2, "会話", 2)
	event.ObjsNextMotion(2, "立ち", 4)
	event.SetPakuAnim(2, "通常口パク")
	helper_c3ce9c48(4280110)
	if vm.skipping() then
		return skip(33)
	end
	helper_e2d04ed9(2)
	if vm.skipping() then
		return skip(34)
	end
	event.ObjsSetMotion(0, "会話", 2)
	event.ObjsNextMotion(0, "立ち", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_c3ce9c48(4280120)
	if vm.skipping() then
		return skip(35)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_c3ce9c48(4280125)
	if vm.skipping() then
		return skip(36)
	end
	helper_e2d04ed9(0)
	if vm.skipping() then
		return skip(37)
	end
	event.ObjsSetMotion(2, "会話", 2)
	event.ObjsNextMotion(2, "立ち", 4)
	event.SetPakuAnim(2, "通常口パク")
	helper_c3ce9c48(4280130)
	if vm.skipping() then
		return skip(38)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_c3ce9c48(4280135)
	if vm.skipping() then
		return skip(39)
	end
	helper_e2d04ed9(2)
	if vm.skipping() then
		return skip(40)
	end
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "まばたき目パチ")
	event.SetPakuAnim(0, "通常口パク")
	helper_c3ce9c48(4280140)
	if vm.skipping() then
		return skip(41)
	end
	event.CmrsSetPos(88.52, 13.64, 103.92)
	event.CmrsSetRef(61.13, 17.27, 120.58)
	event.ObjsSetMotion(2, "会話", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.ObjsColorDelay(4, 30)
	event.ObjsSetColor(4, 128, 128, 128, 128, 30)
	event.SetPakuAnim(2, "わらい口パク")
	helper_c3ce9c48(4280150)
	if vm.skipping() then
		return skip(42)
	end
	helper_e2d04ed9(4)
	if vm.skipping() then
		return skip(43)
	end
	event.SetPakuAnim(2, "わらい口パク")
	helper_c3ce9c48(4280160)
	if vm.skipping() then
		return skip(44)
	end
	event.ObjsColorDelay(5, 30)
	event.ObjsSetColor(5, 128, 128, 128, 128, 30)
	event.SetPakuAnim(2, "わらい口パク")
	helper_c3ce9c48(4280170)
	if vm.skipping() then
		return skip(45)
	end
	helper_e2d04ed9(5)
	if vm.skipping() then
		return skip(46)
	end
	event.SetPakuAnim(2, "わらい口パク")
	helper_c3ce9c48(4280180)
	if vm.skipping() then
		return skip(47)
	end
	event.ObjsSetColor(4, 128, 128, 128, 0)
	event.ObjsSetColor(5, 128, 128, 128, 0)
	event.CmrsSetPos(92.81, 38.23, 102.21)
	event.CmrsSetRef(58.75, 11.98, 119.86)
	event.ObjsSetMotion(2, "会話", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.SetPakuAnim(2, "通常口パク")
	helper_c3ce9c48(4280190)
	if vm.skipping() then
		return skip(48)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_c3ce9c48(4280200)
	if vm.skipping() then
		return skip(49)
	end
	helper_e2d04ed9(2)
	if vm.skipping() then
		return skip(50)
	end
	event.CmrsSetPos(131.77, 54.55, 45.18)
	event.CmrsSetRef(63.6, 14.05, 123.57)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.SetPakuAnim(2, "通常口パク")
	helper_c3ce9c48(4280210)
	if vm.skipping() then
		return skip(51)
	end
	event.SndSePlay(var2, 4)
	event.ObjsSetMotion(2, "歩き")
	event.ObjsMotionDelay(2, 46)
	event.ObjsSetMotion(2, "立ち")
	event.ObjsMove(2, 20.0, 0.0, 120.0, 46)
	event.ObjsRotation(2, 0.0, -1.57, 0.0, 10)
	helper_e2d04ed9(2)
	if vm.skipping() then
		return skip(52)
	end
	helper_ed0a80b8(8)
	if vm.skipping() then
		return skip(53)
	end
	event.ObjsSetMotion(2, "向く（研究員）in", 6)
	event.ObjsNextMotion(2, "向く（研究員）ループ", 4)
	event.SetPakuAnim(2, "通常口パク")
	helper_c3ce9c48(4280220)
	if vm.skipping() then
		return skip(54)
	end
	helper_e2d04ed9(2)
	if vm.skipping() then
		return skip(55)
	end
	helper_c3ce9c48(4280230)
	if vm.skipping() then
		return skip(56)
	end
	event.CmrsSetPos(42.44, 8.84, 186.99)
	event.CmrsSetRef(10.97, 20.1, 123.47)
	event.ObjsSetPos(3, -3.58, 0.0, 164.54)
	event.ObjsSetRot(3, 0.0, 2.64, 0.0)
	event.ObjsMove(3, 8.02, 0.0, 141.96, 30)
	event.ObjsSetMotion(3, "歩き", 4)
	event.ObjsMotionDelay(3, 30)
	event.ObjsSetMotion(3, "立ち(下向き）")
	event.ObjsSetMotion(2, "立ち（見上げ）", 4)
	event.ObjsSetRot(2, 0.0, -1.09, 0.0)
	helper_e2d04ed9(3)
	if vm.skipping() then
		return skip(57)
	end
	event.ObjsSetMotion(2, "会話（見上げ）", 6)
	event.ObjsNextMotion(2, "立ち（見上げ）", 4)
	event.SetPakuAnim(2, "通常口パク")
	helper_c3ce9c48(4280240)
	if vm.skipping() then
		return skip(58)
	end
	helper_e2d04ed9(2)
	if vm.skipping() then
		return skip(59)
	end
	event.ObjsSetMotion(3, "はっ", 6)
	event.ObjsNextMotion(3, "立ち(下向き）", 4)
	helper_c3ce9c48(4280250)
	if vm.skipping() then
		return skip(60)
	end
	helper_e2d04ed9(3)
	if vm.skipping() then
		return skip(61)
	end
	event.ObjsMove(3, -70.0, 0.0, 141.96, 40)
	event.ObjsRotation(3, 0.0, -1.57, 0.0, 8)
	event.ObjsSetMotion(3, "走り")
	helper_e2d04ed9(3)
	if vm.skipping() then
		return skip(62)
	end
	event.ObjsSetMotion(3, "立ち")
	event.CharaActive(36)
	event.ObjsSetRot(3, 0.0, 1.57, 0.0)
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(63)
	end
	event.ObjsSetMotion(3, "走り", 4)
	event.ObjsMotionDelay(3, 40)
	event.ObjsSetMotion(3, "立ち(持ち）")
	event.ObjsMove(3, 12.68, 0.0, 141.55, 40)
	event.ObjsRotDelay(3, 32)
	event.ObjsRotation(3, 0.0, 2.64, 0.0, 8)
	helper_e2d04ed9(3)
	if vm.skipping() then
		return skip(64)
	end
	helper_ed0a80b8(6)
	if vm.skipping() then
		return skip(65)
	end
	event.SndSePlay(var2, 5)
	event.ObjsSetMotion(3, "渡すin", 6)
	event.ObjsNextMotion(3, "渡すループ", 4)
	event.ObjsSetMotion(2, "受け取るin", 6)
	event.ObjsNextMotion(2, "受け取るループ", 4)
	helper_e2d04ed9(3)
	if vm.skipping() then
		return skip(66)
	end
	event.DelReference(36)
	event.SetReference(34, "h", 36)
	event.ObjsSetMotion(3, "渡すout", 6)
	event.ObjsNextMotion(3, "立ち", 4)
	event.SetPakuAnim(2, "通常口パク")
	helper_c3ce9c48(4280260)
	if vm.skipping() then
		return skip(67)
	end
	helper_e2d04ed9(3)
	if vm.skipping() then
		return skip(68)
	end
	event.EohSetPos(3, -55.15, 1.09, 220.25)
	event.EohSetRot(3, 0.0, 1.08, 0.0)
	event.EohSetMotion(3, "座る", 4)
	event.CmrsSetPos(16.79, 44.45, 119.66)
	event.CmrsSetRef(102.21, 4.83, 119.41)
	event.ObjsSetRot(2, 0.0, 1.47, 0.0)
	event.ObjsSetPos(2, 50.0, 0.0, 120.0)
	event.ObjsMove(2, 80.0, 0.0, 127.0, 46)
	event.ObjsSetMotion(2, "歩き（持ち）", 4)
	event.ObjsMotionDelay(2, 46)
	event.ObjsSetMotion(2, "立ち（持ち）")
	helper_e2d04ed9(2)
	if vm.skipping() then
		return skip(69)
	end
	helper_ed0a80b8(4)
	if vm.skipping() then
		return skip(70)
	end
	event.SndSePlay(var2, 6)
	event.ObjsSetMotion(2, "渡すin", 6)
	event.ObjsNextMotion(2, "渡すループ", 4)
	event.SetPakuAnim(2, "通常口パク")
	helper_c3ce9c48(4280270)
	if vm.skipping() then
		return skip(71)
	end
	event.ObjsSetMotion(0, "うけとる", 6)
	event.ObjsNextMotion(0, "うけとるL", 4)
	helper_e2d04ed9(0)
	if vm.skipping() then
		return skip(72)
	end
	event.SndSePlay(var2, 7)
	helper_ed0a80b8(10)
	if vm.skipping() then
		return skip(73)
	end
	event.CmrsSetPos(61.46, 21.85, 115.36)
	event.CmrsSetRef(100.98, 26.73, 130.47)
	event.CmrsMove2(70.43, 23.74, 118.79, 100.98, 26.73, 130.47, 90, 2, 0.3)
	event.ObjsSetPos(2, 60.0, 0.0, 120.0)
	event.ObjsSetRot(2, 0.0, 1.57, 0.0)
	event.ObjsSetMotion(2, "立ち", 4)
	event.CharaActive(37)
	event.ObjsSetMotion(0, "ほんやく機ゲット", 4, -1.0, 1)
	event.SndPauseBgm()
	event.CharaActive(1, 38)
	event.SetCharaPos(38, 93.41, 28.09, 127.58)
	event.SetCharaRot(38, 0.0, 1.2, 0.0)
	event.SetMotion(38, "発動", 6)
	helper_ed0a80b8(2)
	if vm.skipping() then
		return skip(74)
	end
	event.SndSePlay(var1, 0)
	helper_ed0a80b8(120)
	if vm.skipping() then
		return skip(75)
	end
	event.SndSePlay(var2, 8)
	helper_8508907e(373, 1)
	if vm.skipping() then
		return skip(76)
	end
	event.CharaActive(0, 37)
	event.CharaActive(0, 36)
	event.CharaActive(0, 38)
	event.PlayBgm(0)
	event.CmrsSetPos(123.51, 47.51, 60.57)
	event.CmrsSetRef(72.34, -0.96, 139.59)
	event.ObjsSetMotion(0, "会話", 6, -1.0, 1)
	event.ObjsNextMotion(0, "立ち", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_c3ce9c48(4280280)
	if vm.skipping() then
		return skip(77)
	end
	helper_e2d04ed9(0)
	if vm.skipping() then
		return skip(78)
	end
	event.SetPakuAnim(2, "通常口パク")
	helper_c3ce9c48(4280290)
	if vm.skipping() then
		return skip(79)
	end
	event.CmrsSetPos(88.52, 13.64, 103.92)
	event.CmrsSetRef(61.13, 17.27, 120.58)
	event.ObjsSetMotion(2, "会話", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.SetPakuAnim(2, "通常口パク")
	helper_c3ce9c48(4280300)
	if vm.skipping() then
		return skip(80)
	end
	helper_e2d04ed9(2)
	if vm.skipping() then
		return skip(81)
	end
	event.CmrsSetPos(25.57, 38.04, 119.09)
	event.CmrsSetRef(88.34, 14.0, 120.01)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "無表情")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.ObjsSetMotion(2, "会話", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.SetPakuAnim(2, "通常口パク")
	helper_c3ce9c48(4280310)
	if vm.skipping() then
		return skip(82)
	end
	helper_e2d04ed9(2)
	if vm.skipping() then
		return skip(83)
	end
	event.ObjsSetMotion(0, "考える", 6)
	event.ObjsNextMotion(0, "考えるL", 4)
	event.SetPakuAnim(0, "真剣口パク")
	helper_c3ce9c48(4280320)
	if vm.skipping() then
		return skip(84)
	end
	helper_e2d04ed9(0)
	if vm.skipping() then
		return skip(85)
	end
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.ObjsSetMotion(0, "考える戻り", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_c3ce9c48(4280330)
	if vm.skipping() then
		return skip(86)
	end
	event.ObjsSetMotion(2, "またねin", 6)
	event.ObjsNextMotion(2, "またねループ", 4)
	event.SetPakuAnim(2, "わらい口パク")
	helper_c3ce9c48(4280340)
	if vm.skipping() then
		return skip(87)
	end
	helper_e2d04ed9(2)
	if vm.skipping() then
		return skip(88)
	end
	event.SetFadeOut(30)
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(89)
	end
	return part2()
end

--- Helper function.
local function helper_1c274(arg0: f32)
	local var2: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	do
		local _, out2, _ = event.GetCharaRot(0)
		var2 = out2 or var2
	end
	var4 = vm.f32(arg0 + vm.f32(6.2831855))
	var5 = vm.f32(var2 + vm.f32(6.2831855))
	var6 = vm.f32(var4 - var5)
	if var6 < 0 then
		var6 = vm.f32(var6 * -1.0)
	end
	if vm.f32(3.1415927) < var6 then
		var6 = vm.f32(var6 - vm.f32(3.1415927))
	end
	if vm.f32(3.1415927) < var6 then
		var6 = vm.f32(var6 - vm.f32(3.1415927))
	end
	event.Initialize()
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsRotation(0, 0.0, arg0, 0.0, vm.ftoi(vm.f32(var6 * 10.0)))
	helper_e2d04ed9(0)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsSetMotion(0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_10b3c()
	local player_chara: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local argc: s32 = 0
	local var9: s32 = 0
	local flag_5: s32 = 0
	local flag_6: s32 = 0
	local flag_7: s32 = 0
	local flag_8: s32 = 0
	local active_chr_no: s32 = 0
	local player_chara_2: s32 = 0
	local var16: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_635ee3fd(0, -1, var1, player_chara, 0)
		end
		if at <= 2 then
			var3 = 1
			helper_b578b747(var1, -1, 0, 0)
		end
		if at <= 3 then
			helper_635ee3fd(0, -1, var1, player_chara, 0)
		end
		if at <= 4 then
			helper_e7da2113(player_chara_2, var22)
		end
		if at <= 5 then
			helper_635ee3fd(0, -1, var1, player_chara_2, 0)
		end
	end
	player_chara = event.GetControlChrid() or player_chara
	var1 = event.GetEventData_2(13) or var1
	var2 = event.GetEventData_2(14) or var2
	print("talk_chara_id=", var1, "talk_chara=", var2, "\n")
	event.CtrlcStay()
	event.SetAi(0, var1)
	event.SetMesShippo(0, 1)
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Tagchen.\nSch[UNI00f6]nes Wetter, nicht wahr?")
	var3 = 0
	if var2 == 300 then
		flag = event.GetFlag(640) or flag
		if flag == 0 then
			flag_2 = event.GetFlag(456) or flag_2
			if flag_2 == 0 then
				event.MesMake_2(
					0,
					"Wie? Wer seid ihr ...? Dies ist \ndie weltbeste Forschungs-\neinrichtung, das Mondweisheits-<page>Laboratorium. Es sieht vielleicht im\nMoment nicht beeindruckend aus, aber\nwir sollten dennoch unsere<page>Forschungen hier beenden\nk[UNI00f6]nnen."
				)
			else
				event.MesMake_2(
					0,
					"Worte allein k[UNI00f6]nnen nicht\nbeschreiben, wie gro[UNI00df]artig das\nMondlabor ist.<page>Man muss es gesehen haben."
				)
			end
		else
			event.MesMake_2(
				0,
				"Wenn Griffon nicht beseitigt\nwird, kann die Geschichte nie wieder\nnormal werden.<page>Seine blo[UNI00df]e Existenz\nverzerrt den Lauf der\nGeschichte."
			)
		end
	end
	if var2 == 301 then
		flag_3 = event.GetFlag(420) or flag_3
		if flag_3 == 0 then
			flag_4 = event.GetFlag(408) or flag_4
			if flag_4 == 0 then
				event.MesMake_2(0, "Haahn, schuuu,\nhaahn, schuuu.")
				var3 = 2
			else
				argc = event.GetInventionId(309) or argc
				if argc < 0 then
					event.MesMake_2(
						0,
						"Hier ein paar Tipps zur\nErfindung eines Aquariums. Eine\nHolzkiste, ein Fenster und ein<page>Springbrunnen. Die gibt's doch\nin eurer Stadt, nicht wahr?"
					)
				else
					var9 = event.GetSavedataEtc(2) or var9
					if var9 == 0 then
						event.MesMake_2(
							0,
							'Verf[UNI00fc]ttere erst einen "Elektro-Wurm"\nan einen Fisch im Aquarium,\num ihn unter Strom zu setzen.<page>Verf[UNI00fc]ttere dann den Fisch\nan den Shigura.\nHast du das verstanden?'
						)
					else
						event.MesMake_2(
							0,
							"Oh, du hast den Fisch, ja?\nGib ihn jetzt dem Shigura.\nDas schaffst du locker, was?"
						)
					end
				end
			end
		else
			event.MesMake_2(
				0,
				"So! Du hast es geschafft!\nMeine Erfindung hat dir\nalso geholfen. Ja, tats[UNI00e4]chlich."
			)
		end
	end
	if var2 == 302 then
		event.MesMake_2(
			0,
			"Ob Osmond oder der Forschungs-\nleiter - hier gibt's einfach\nviel zu viele Verr[UNI00fc]ckte."
		)
	end
	if var2 == 303 then
		flag_5 = event.GetFlag(640) or flag_5
		if flag_5 == 0 then
			flag_6 = event.GetFlag(616) or flag_6
			if flag_6 == 0 then
				flag_7 = event.GetFlag(600) or flag_7
				if flag_7 == 0 then
					flag_8 = event.GetFlag(448) or flag_8
					if flag_8 == 0 then
						event.MesMake_2(
							0,
							"Pass gut auf das Muschel-\nPhon auf, ja? Das ist eine der wichtigsten\nErfindungen des Mondlabors."
						)
					else
						event.MesMake_2(
							0,
							"Die Zeit dr[UNI00e4]ngt. Du musst dich\nbeeilen, Griffons Streitmacht n[UNI00e4]hert\nsich Elena und hat sie bald ..."
						)
					end
				else
					event.MesMake_2(0, "Was dieser Griffon wohl f[UNI00fc]r\nein Mensch ist ...")
				end
			else
				event.MesMake_2(
					0,
					"Edelsteine suchst du, ja ...?\nDas sind Weisheitskristalle, die\ndie Alten schufen.<page>Einer Analyse des Mondlabors\nzufolge gibt es sie an vier\nOrten:"
				)
				helper_fc5f5017(player_chara, var1, 0)
				if vm.skipping() then
					return skip(1)
				end
				helper_635ee3fd(0, -1, var1, player_chara, 0)
				if vm.skipping() then
					return skip(2)
				end
				var3 = 1
				event.MesMake_2(
					0,
					"Im Regenbogen-Schmetterling-Wald,\nim Sternenlicht-Canyon, in der\nH[UNI00f6]hle des Meeresdonners und auf dem<page>Gundorberg. Am Eingang dieser Orte\nm[UNI00fc]sste ein Sternsymbol sein, also\nhalte die Augen offen."
				)
			end
		else
			event.MesMake_2(
				0,
				"Na gut, es ist an der Zeit, Griffon\nauszuschalten. Das Schicksal der\nWelt liegt in deinen H[UNI00e4]nden.<page>Viel Gl[UNI00fc]ck!"
			)
		end
	end
	if var2 == 304 then
		event.MesMake_2(
			0,
			"Hier im Labor geht's nur um\nFertigkeit. Mit der richtigen Fertigkeit\nk[UNI00f6]nnte selbst ein Kind hier<page>zum Chef werden."
		)
	end
	if var2 == 305 then
		event.MesMake_2(
			0,
			"Die Mondsteine, die die Shigura\nuns bringen, helfen uns, einen klaren\nKopf zu behalten und uns zu<page>konzentrieren. Aber was die\nMondsteine genau sind, wei[UNI00df]\nich leider nicht ..."
		)
	end
	if var2 == 306 then
		event.MesMake_2(
			0,
			"Ein Labor auf dem Meer ist ganz\ncool, oder? Wei[UNI00df]t du, wie schwer\nich schuften musste, um hier<page>einen Job zu kriegen?"
		)
	end
	if var2 == 307 then
		event.MesMake_2(
			0,
			"Was h[UNI00e4]ltst du vom Design des\nMondlabors? Ich frage mich, wer diese\nVergn[UNI00fc]gungspark-Idee hatte ..."
		)
	end
	if var2 == 308 then
		event.MesMake_2(
			0,
			"Eines Tages [UNI00fc]berfl[UNI00fc]gele ich\nalle und zeige, wie schlau ich bin.\nHier geht's nur um Fertigkeit. "
		)
	end
	if var2 == 309 then
		event.MesMake_2(
			0,
			'Ich respektiere den Chef sehr.\nDas muss man einfach, wenn\njemand in seinem Alter einen<page>40-seitigen Bestseller namens\n"Handbuch f[UNI00fc]r Top-Forscher" schreibt.'
		)
	end
	if var2 == 310 then
		event.MesMake_2(
			0,
			"Ich bin noch recht neu hier.\nIch lerne viel und will sp[UNI00e4]ter\nmal ein Top-Forscher werden."
		)
	end
	if var2 == 311 then
		event.MesMake_2(
			0,
			"Die Aussicht aufs Meer aus diesem\nLabor ist unglaublich.<page>Am Horizont vereinigen sich die\nDunkelheit des Meeres und die\ndes Himmels."
		)
	end
	if var2 == 312 then
		event.MesMake_2(0, "Dies ist Labor Nr. 2.<page>Im Mondlabor hat jede\nAbteilung ihr eigenes\nForschungsgebiet.")
	end
	if var2 == 313 then
		event.MesMake_2(
			0,
			"Hier im Mondlabor simulieren wir\neine n[UNI00e4]chtliche Umwelt, um die\nKraft der Mondsteine zu verst[UNI00e4]rken."
		)
	end
	if var2 == 314 then
		event.MesMake_2(
			0,
			"Als ich hier angefangen habe,\nkonnte ich die Labors auch nie\nauseinanderhalten. Ich helfe dir.<page>Labor 1 ist rot, Labor 2\nist blau, Labor 3 ist lila\nund Labor 4 gr[UNI00fc]n.<page>Jedes Labor hat also seine\neigene Farbe."
		)
	end
	if var2 == 315 then
		event.MesMake_2(0, "Das Emblem [UNI00fc]ber dem Zentral-\nLabor ist dem Mond\nnachempfunden.")
	end
	if var2 == 316 then
		event.MesMake_2(
			0,
			"Angeblich wurde dieses Monlabor\nmithilfe von Mondsteinen gebaut,\ndie ein Seedrache namens<page>Shingala herbrachte. Manche dieser\nSeedrachen m[UNI00fc]ssen wohl recht\nschlau sein!"
		)
	end
	if var2 == 317 then
		event.MesMake_2(
			0,
			"Erz[UNI00e4]hl ihm nicht, dass ich das\ngesagt habe, aber<page>Osmonds so genannte Witze\nstehen uns bis hier.\nSie machen einen krank. "
		)
	end
	if var2 == 318 then
		event.MesMake_2(
			0,
			"Ich kann nicht l[UNI00fc]gen. Ja, auch\nich habe [UNI00fc]ber den Elektro-Wurm\ngeforscht. Jetzt hab ich ein<page>neues Projekt. Aber ich darf's\nnicht verraten! Streng geheim!\nAusgeplaudert wird nichts!"
		)
	end
	if var2 == 319 then
		event.MesMake_2(
			0,
			"Wie? Ihr wollt auch Forscher\nwerden?<page>Es ist nicht leicht, hier\naufgenommen zu werden.\nDie Konkurrenz ist hart."
		)
	end
	if var2 == 320 then
		event.MesMake_2(
			0,
			"Manche Forscher m[UNI00f6]gen das Design\ndes Mondlabors nicht. Ich finde\nes eigentlich cool ...<page>Aber damit geh[UNI00f6]re ich\nwohl zur Minderheit."
		)
	end
	if var2 == 321 then
		event.MesMake_2(
			0,
			"Wir sprechen gerade [UNI00fc]ber streng\ngeheime Forschungsdaten.<page>K[UNI00f6]nntest du uns bitte\nallein lassen?"
		)
	end
	if var2 == 322 then
		event.MesMake_2(
			0,
			"Es tut mir sehr Leid,\naber wir besprechen gerade streng\ngeheime Forschungsdaten.<page>Das geht nicht, wenn du hier\nherumstehst, also ..."
		)
	end
	if var2 == 323 then
		event.MesMake_2(
			0,
			"Nat[UNI00fc]rlich ist Dr. Nobb begabt,\naber auch sehr flei[UNI00df]ig.<page>Ich bin nichts dagegen ...\nWie ein Staubkorn ..."
		)
	end
	if var2 == 324 then
		event.MesMake_2(
			0,
			"Du? Ich hab geh[UNI00f6]rt, du hast mit\nDr. Osmond gestritten.<page>Das ist nicht schlecht - eigentlich\nsogar gut. Wir entdecken nur\ndann Neues, wenn wir alles<page>in Frage stellen."
		)
	end
	if var2 == 325 then
		event.MesMake_2(
			0,
			"Das helle Licht st[UNI00f6]rt dich, ja?<page>Ihr Besucher aus der Vergangenheit\nm[UNI00fc]sst euch wohl einfach\netwas eingew[UNI00f6]hnen."
		)
	end
	if var2 == 326 then
		event.MesMake_2(
			0,
			"Ach, ich mach nur ein P[UNI00e4]uschen.<page>Man muss seinem Hirn auch mal\nRuhe g[UNI00f6]nnen, sonst bringt\nman's irgendwann nicht mehr."
		)
	end
	if var2 == 327 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no ~= 1 then
			event.MesMake_2(
				0,
				"Du sollst ein guter Erfinder sein.\nWie w[UNI00e4]r's - kommst du zu uns,\nwenn du gro[UNI00df] bist?<page>Hey, wenn du erwachsen wirst, wird\ndieses Mondlabor gerade neu\neingerichtet worden sein.<page>Die sind bestimmt froh,\nwenn du kommst."
			)
		else
			event.MesMake_2(
				0,
				"Findest du Erfinder nicht auch\ntotal m[UNI00e4]nnlich?<page>Aber verlieb dich blo[UNI00df] nicht\nin mich, klar? Meine Arbeit\nist mein Leben.<page>Es w[UNI00fc]rde nie funktionieren."
			)
		end
	end
	if var2 == 328 then
		event.MesMake_2(
			0,
			"Ich hab eine revolution[UNI00e4]re Idee.\nSie soll erm[UNI00f6]glichen, dass Monster\nund Menschen zusammenleben.<page>Ich baue eine Maschine,\ndie die menschliche\nSprache versteht."
		)
	end
	if var2 == 329 then
		event.MesMake_2(
			0,
			"Die Mondsteine sind die\nGrundlage des Mondlabors.<page>Ohne sie w[UNI00fc]rde hier\nsofort alles stillstehen."
		)
	end
	if var3 == 0 then
		helper_b578b747(var1, -1, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
	end
	if var3 == 1 then
		helper_635ee3fd(0, -1, var1, player_chara, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(var1, "立ち")
		event.Finish()
	end
	if var3 == 2 then
		event.SetCameraPos(1.39, 51.09, 278.55)
		event.SetCameraRef(-54.8, 23.29, 223.57)
		player_chara_2 = event.GetControlChrid() or player_chara_2
		do
			local out1, _, out3 = event.GetCharaPos(player_chara_2)
			var16 = out1 or var16
			var18 = out3 or var18
		end
		do
			local out1, _, out3 = event.GetCharaPos(var1)
			var19 = out1 or var19
			var21 = out3 or var21
		end
		var22 = event.GetRotLookPos(var19 - var16, var21 - var18) or var22
		helper_e7da2113(player_chara_2, var22)
		if vm.skipping() then
			return skip(5)
		end
		event.SetCharaRot(player_chara_2, 0.0, var22, 0.0)
		event.SetMotion(player_chara_2, "立ち")
		helper_635ee3fd(0, -1, var1, player_chara_2, 0)
		if vm.skipping() then
			return skip(6)
		end
		event.ResetCamera(1, 3.1415927)
	end
	event.SetAi(1, var1)
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
script[100] = function()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1ef0d4b2()
	flag = event.GetFlag(400) or flag
	if flag == 1 then
		flag_2 = event.GetFlag(428) or flag_2
		if flag_2 == 0 then
			event.AddItem(373)
			helper_13ec8()
			if vm.skipping() then
				return skip(1)
			end
			return
		end
	end
	helper_ac6949ab(62.0, vm.f32(69.1), -197.0, vm.f32(1.57))
	event.ResetCamera(1, 3.14, 10)
	event.SetFadeIn(30)
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_13ec8()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 400.
script[400] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_ed0a80b8(30)
		end
	end
	helper_1c274(vm.f32(3.1415927))
	if vm.skipping() then
		return skip(1)
	end
	event.SetMotion(0, "立ち")
	var0 = event.GetSndId(2) or var0
	event.SndSePlay(var0, 94)
	event.SetFadeOut(30)
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(2)
	end
	event.MapJump(-1, "f03")
	if vm.wait() then
		return skip(3)
	end
end

--- Program 1000.
script[1000] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_10b3c()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 14280.
script[14280] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1ef0d4b2()
	helper_13ec8()
	if vm.skipping() then
		return skip(1)
	end
end

return script
