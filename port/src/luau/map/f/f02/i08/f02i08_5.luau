--!strict
-- map/f/f02/i08/f02i08_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_10d80545 = require("@lib/event/helper_10d80545")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_52c8e591 = require("@lib/event/helper_52c8e591")
local helper_93d5f4e9 = require("@lib/event/helper_93d5f4e9")
local helper_a1c34b66 = require("@lib/event/helper_a1c34b66")
local helper_a348cd1a = require("@lib/event/helper_a348cd1a")
local helper_b2621100 = require("@lib/event/helper_b2621100")
local helper_b527b7d3 = require("@lib/event/helper_b527b7d3")
local helper_befc1874 = require("@lib/event/helper_befc1874")
local helper_dd5d7f5f = require("@lib/event/helper_dd5d7f5f")
local helper_e84a97e1 = require("@lib/event/helper_e84a97e1")
local helper_efffcfbb = require("@lib/event/helper_efffcfbb")

--- Helper function.
local function helper_1c720(arg0: s32)
	local chara_id: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	chara_id = event.GetCharaId(200) or chara_id
	event.CharaActive(arg0, chara_id)
end

--- Helper function.
local function helper_1340c()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local block: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 41 then
			if at <= 1 then
				helper_10d80545()
			end
			if at <= 2 then
				helper_93d5f4e9(3200010)
			end
			if at <= 3 then
				helper_a1c34b66(0)
			end
			if at <= 4 then
				helper_93d5f4e9(3200020)
			end
			if at <= 5 then
				helper_a1c34b66(1)
			end
			if at <= 6 then
				helper_efffcfbb(4)
			end
			if at <= 7 then
				helper_a1c34b66(1)
			end
			if at <= 8 then
				helper_a1c34b66(1)
			end
			if at <= 9 then
				helper_efffcfbb(10)
			end
			if at <= 10 then
				helper_93d5f4e9(3200030)
			end
			if at <= 11 then
				helper_a1c34b66(2)
			end
			if at <= 12 then
				helper_a1c34b66(2)
			end
			if at <= 13 then
				helper_93d5f4e9(3200040)
			end
			if at <= 14 then
				helper_a1c34b66(2)
			end
			if at <= 15 then
				helper_93d5f4e9(3200050)
			end
			if at <= 16 then
				helper_93d5f4e9(3200055)
			end
			if at <= 17 then
				helper_a1c34b66(1)
			end
			if at <= 18 then
				helper_93d5f4e9(3200060)
			end
			if at <= 19 then
				helper_93d5f4e9(3200065)
			end
			if at <= 20 then
				helper_a1c34b66(1)
			end
			if at <= 21 then
				helper_93d5f4e9(3200070)
			end
			if at <= 22 then
				helper_93d5f4e9(3200075)
			end
			if at <= 23 then
				helper_a1c34b66(2)
			end
			if at <= 24 then
				helper_93d5f4e9(3200080)
			end
			if at <= 25 then
				helper_93d5f4e9(3200090)
			end
			if at <= 26 then
				helper_93d5f4e9(3200095)
			end
			if at <= 27 then
				helper_a1c34b66(2)
			end
			if at <= 28 then
				helper_93d5f4e9(3200100)
			end
			if at <= 29 then
				helper_93d5f4e9(3200110)
			end
			if at <= 30 then
				helper_a1c34b66(1)
			end
			if at <= 31 then
				helper_93d5f4e9(3200120)
			end
			if at <= 32 then
				helper_a1c34b66(0)
			end
			if at <= 33 then
				helper_93d5f4e9(3200130)
			end
			if at <= 34 then
				helper_a1c34b66(1)
			end
			if at <= 35 then
				helper_93d5f4e9(3200140)
			end
			if at <= 36 then
				helper_a1c34b66(0)
			end
			if at <= 37 then
				helper_a1c34b66(2)
			end
			if at <= 38 then
				helper_efffcfbb(10)
			end
			if at <= 39 then
				helper_efffcfbb(30)
			end
			if at <= 40 then
				helper_efffcfbb(30)
			end
			if vm.skip_end() then
				return skip(42)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var0, 5)
		event.SndSeStop(var0, 6)
		event.SpriteSetDraw(0, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.DeleteChara(35)
		event.DelImg(0)
		event.LoadMes(0, -1)
		event.SetCharaPos(0, 0.0, -0.43, -50.0)
		event.SetCharaRot(0, 0.0, 3.14, 0.0)
		event.SetMotion(0, "立ち", 4)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 3.14, 10.0)
		event.SetFadeIn(30)
	end
	event.SetFadeOut(0)
	event.SetFlag(320, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetProjection(524.9)
	event.LoadSound(3500)
	var0 = event.SndLoadSound(3500) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.ChangeDir("event/e300/e320/")
	event.LoadMes(0, 5, "e320_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e320_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e320_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e320_raochao.gltf", "info", 35)
	event.CharaActive(35)
	event.EohSyncChara(2, 35)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	block = event.LoadImg_4(5, "e320.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e32001", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 448)
	event.SpriteSetPutsize(0, 512, 448)
	event.SpriteSetPos(0, 256, 224)
	event.SpriteSetDraw(0, 0)
	event.EohSyncSprite(3, 0)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 33)
		event.LoadEquip(5, 0, 4, "info", 33)
		event.LoadEquip(5, 0, 3, "info", 33)
		event.LoadEquip(5, 0, 2, "info", 33, 34)
		event.LoadMotion(5, "event/e300/e320/e320_mints.gltf", "info", 33)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 33)
		event.EohSyncChara(0, 33)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 33)
		event.LoadEquip(5, 1, 4, "info", 33)
		event.LoadEquip(5, 1, 3, "info", 33)
		event.LoadEquip(5, 1, 2, "info", 33, 34)
		event.LoadMotion(5, "event/e300/e320/e320_monica.gltf", "info", 33)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 33)
		event.EohSyncChara(1, 33)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(33)
	event.CharaActive(34)
	event.EohSetPos(0, 8.0, 20.0, -160.0)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohResetDaPosition(0)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetFootSoundId(0, 4)
	event.EohSetPos(1, -8.0, 20.0, -160.0)
	event.EohSetRot(1, 0.0, 0.0, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohResetDaPosition(1)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.EohSetFootSoundId(1, 4)
	event.EohSetPos(2, 0.0, -0.43, 145.0)
	event.EohSetRot(2, 0.0, 3.14, 0.0)
	event.EohSetMotion(2, "ごそごそ", 4)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "目パチ")
	event.EohSetFootSoundId(2, 2)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(60.03, 24.04, -18.65)
	event.CmrsSetRef(-17.47, 39.8, -140.45)
	event.SndSePlay(var0, 5)
	event.SndSePlay(var0, 6)
	event.SetFadeIn(30)
	helper_efffcfbb(40)
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(78.0, 90.0, -105.0)
	event.CmrsSetRef(0.0, 20.0, 120.0)
	event.CmrsMoveAhd2(-2.81, 70.0, 238.14, 60, 0, 1.0)
	helper_10d80545()
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(-48.4, 22.41, -85.71)
	event.CmrsSetRef(-0.1, 33.66, -146.03)
	event.ObjsMove(0, 8.0, 20.0, -140.0, 30)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMotionDelay(0, 30)
	event.ObjsSetMotion(0, "立ち")
	event.SetPakuAnim(0, "わらい口パク")
	helper_93d5f4e9(3200010)
	if vm.skipping() then
		return skip(3)
	end
	helper_a1c34b66(0)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(1, "うなづく", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_93d5f4e9(3200020)
	if vm.skipping() then
		return skip(5)
	end
	helper_a1c34b66(1)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsMove(0, 8.0, 10.2, -100.0, 40, 1)
	event.ObjsSetMotion(0, "歩き")
	helper_efffcfbb(4)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsMove(1, -8.0, 10.2, -100.0, 60, 1)
	event.ObjsSetMotion(1, "歩き")
	helper_a1c34b66(1)
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsSetPos(-75.76, 74.49, -34.88)
	event.CmrsSetRef(15.11, 11.0, 88.74)
	event.ObjsSetPos(0, 10.0, -0.43, 0.0)
	event.ObjsMove(0, 10.0, -0.43, 60.0, 60)
	event.ObjsMotionDelay(0, 60)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsSetPos(1, -10.0, -0.43, -4.0)
	event.ObjsMove(1, -10.0, -0.43, 60.0, 64)
	event.ObjsMotionDelay(1, 64)
	event.ObjsSetMotion(1, "立ち")
	helper_a1c34b66(1)
	if vm.skipping() then
		return skip(9)
	end
	helper_efffcfbb(10)
	if vm.skipping() then
		return skip(10)
	end
	event.CmrsSetPos(36.25, 36.87, 181.26)
	event.CmrsSetRef(-14.37, 19.74, 89.01)
	event.SetPakuAnim(1, "通常口パク")
	helper_93d5f4e9(3200030)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(-23.83, 31.93, 86.48)
	event.CmrsSetRef(7.19, 26.71, 126.84)
	event.SndSeStop(var0, 6)
	event.SndSePlay(var0, 7)
	event.ObjsSetMotion(2, "振り返る", 2)
	event.ObjsMotionWait(2)
	helper_a1c34b66(2)
	if vm.skipping() then
		return skip(12)
	end
	event.ObjsSetMotion(2, "歩き")
	event.ObjsMove(2, 0.0, -0.43, 125.0, 30)
	event.ObjsMotionDelay(2, 30)
	event.ObjsSetMotion(2, "立ち")
	helper_a1c34b66(2)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsSetMotion(2, "会話2", 2)
	event.ObjsNextMotion(2, "立ち", 4)
	event.SetPakuAnim(2, "口パク")
	helper_93d5f4e9(3200040)
	if vm.skipping() then
		return skip(14)
	end
	helper_a1c34b66(2)
	if vm.skipping() then
		return skip(15)
	end
	event.CmrsSetPos(-33.89, 34.75, 164.03)
	event.CmrsSetRef(6.83, 19.26, 81.57)
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_93d5f4e9(3200050)
	if vm.skipping() then
		return skip(16)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_93d5f4e9(3200055)
	if vm.skipping() then
		return skip(17)
	end
	helper_a1c34b66(1)
	if vm.skipping() then
		return skip(18)
	end
	event.CmrsSetPos(27.91, 33.68, 96.67)
	event.CmrsSetRef(-11.17, 13.8, 49.82)
	event.SetPakuAnim(1, "通常口パク")
	helper_93d5f4e9(3200060)
	if vm.skipping() then
		return skip(19)
	end
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目～真剣目とじ")
	event.ObjsSetMotion(1, "お願い", 2)
	event.ObjsNextMotion(1, "お願いＬ", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_93d5f4e9(3200065)
	if vm.skipping() then
		return skip(20)
	end
	helper_a1c34b66(1)
	if vm.skipping() then
		return skip(21)
	end
	event.CmrsSetPos(0.0, 26.85, 21.57)
	event.CmrsSetRef(0.0, 17.73, 104.2)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "無表情")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.ObjsSetMotion(2, "会話2", 2)
	event.ObjsNextMotion(2, "立ち", 4)
	event.SetPakuAnim(2, "口パク")
	helper_93d5f4e9(3200070)
	if vm.skipping() then
		return skip(22)
	end
	event.SetPakuAnim(2, "口パク")
	helper_93d5f4e9(3200075)
	if vm.skipping() then
		return skip(23)
	end
	helper_a1c34b66(2)
	if vm.skipping() then
		return skip(24)
	end
	event.ObjsSetMotion(1, "お願い戻り", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_93d5f4e9(3200080)
	if vm.skipping() then
		return skip(25)
	end
	event.CmrsSetPos(-23.88, 27.8, 90.51)
	event.CmrsSetRef(5.78, 28.07, 118.34)
	event.ObjsSetMotion(2, "会話2", 2)
	event.ObjsNextMotion(2, "立ち", 4)
	event.SpriteSetDraw(0, 2)
	event.ObjsSetColor(3, 128.0, 128.0, 128.0, 128.0, 30)
	event.SetPakuAnim(2, "口パク")
	helper_93d5f4e9(3200090)
	if vm.skipping() then
		return skip(26)
	end
	event.SetPakuAnim(2, "口パク")
	helper_93d5f4e9(3200095)
	if vm.skipping() then
		return skip(27)
	end
	helper_a1c34b66(2)
	if vm.skipping() then
		return skip(28)
	end
	event.ObjsSetColor(3, 128.0, 128.0, 128.0, 0.0)
	event.SpriteSetDraw(0, 0)
	event.CmrsSetPos(36.94, 35.56, 165.86)
	event.CmrsSetRef(-8.57, 20.03, 83.73)
	event.SetPakuAnim(2, "口パク")
	helper_93d5f4e9(3200100)
	if vm.skipping() then
		return skip(29)
	end
	event.ObjsSetMotion(1, "考え", 2)
	event.ObjsNextMotion(1, "考えＬ", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_93d5f4e9(3200110)
	if vm.skipping() then
		return skip(30)
	end
	helper_a1c34b66(1)
	if vm.skipping() then
		return skip(31)
	end
	event.CmrsSetPos(-21.61, 29.82, 85.96)
	event.CmrsSetRef(4.96, 19.69, 50.88)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "まえ向き～左向き")
	event.ObjsTexaDelay(1, 20)
	event.ObjsTexAnime(1, 1, "左向き目パチ")
	event.ObjsSetMotion(0, "右向く", 6)
	event.ObjsNextMotion(0, "右向く会話", 6)
	event.ObjsNextMotion(0, "右向くL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_93d5f4e9(3200120)
	if vm.skipping() then
		return skip(32)
	end
	helper_a1c34b66(0)
	if vm.skipping() then
		return skip(33)
	end
	event.ObjsSetMotion(1, "考え戻り", 6)
	event.ObjsNextMotion(1, "会話", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.ObjsSeDelay(1, 30)
	event.ObjsSePlay(1, var0, 8)
	event.SetPakuAnim(1, "通常口パク")
	helper_93d5f4e9(3200130)
	if vm.skipping() then
		return skip(34)
	end
	helper_a1c34b66(1)
	if vm.skipping() then
		return skip(35)
	end
	event.CmrsSetPos(-0.23, 59.82, -25.11)
	event.CmrsSetRef(-0.08, 19.69, 71.97)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "無表情")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.ObjsSetMotion(0, "右向く戻り", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_93d5f4e9(3200140)
	if vm.skipping() then
		return skip(36)
	end
	helper_a1c34b66(0)
	if vm.skipping() then
		return skip(37)
	end
	event.ObjsSetMotion(2, "うなづく", 2)
	event.ObjsNextMotion(2, "立ち", 4)
	helper_a1c34b66(2)
	if vm.skipping() then
		return skip(38)
	end
	event.ObjsMove(1, -8.0, 10.2, -10.0, 70)
	event.ObjsRotation(1, 0.0, 3.14, 0.0, 16)
	event.ObjsSetMotion(1, "歩き")
	helper_efffcfbb(10)
	if vm.skipping() then
		return skip(39)
	end
	event.ObjsMove(0, 8.0, 10.2, 0.0, 60)
	event.ObjsRotation(0, 0.0, 3.14, 0.0, 16)
	event.ObjsSetMotion(0, "歩き")
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(40)
	end
	event.SetFadeOut(30)
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(41)
	end
	return part2()
end

--- Helper function.
local function helper_1740c()
	local var0: s32 = 0
	local var1: s32 = 0
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 32 then
			if at <= 1 then
				helper_efffcfbb(4)
			end
			if at <= 2 then
				helper_93d5f4e9(3240010)
			end
			if at <= 3 then
				helper_a1c34b66(2)
			end
			if at <= 4 then
				helper_93d5f4e9(3240020)
			end
			if at <= 5 then
				helper_a1c34b66(1)
			end
			if at <= 6 then
				helper_93d5f4e9(3240030)
			end
			if at <= 7 then
				helper_93d5f4e9(3240035)
			end
			if at <= 8 then
				helper_a1c34b66(2)
			end
			if at <= 9 then
				helper_93d5f4e9(3240040)
			end
			if at <= 10 then
				helper_a1c34b66(0)
			end
			if at <= 11 then
				helper_efffcfbb(30)
			end
			if at <= 12 then
				helper_efffcfbb(30)
			end
			if at <= 13 then
				helper_10d80545()
			end
			if at <= 14 then
				helper_efffcfbb(10)
			end
			if at <= 15 then
				helper_efffcfbb(45)
			end
			if at <= 16 then
				helper_efffcfbb(30)
			end
			if at <= 17 then
				helper_efffcfbb(30)
			end
			if at <= 18 then
				helper_93d5f4e9(3240050)
			end
			if at <= 19 then
				helper_efffcfbb(2)
			end
			if at <= 20 then
				helper_efffcfbb(120)
			end
			if at <= 21 then
				helper_b527b7d3(364, 1)
			end
			if at <= 22 then
				helper_93d5f4e9(3240060)
			end
			if at <= 23 then
				helper_a1c34b66(1)
			end
			if at <= 24 then
				helper_93d5f4e9(3240070)
			end
			if at <= 25 then
				helper_a1c34b66(1)
			end
			if at <= 26 then
				helper_93d5f4e9(3240075)
			end
			if at <= 27 then
				helper_a1c34b66(0)
			end
			if at <= 28 then
				helper_93d5f4e9(3240080)
			end
			if at <= 29 then
				helper_a1c34b66(2)
			end
			if at <= 30 then
				helper_a348cd1a(3240090, 90)
			end
			if at <= 31 then
				helper_efffcfbb(30)
			end
			if vm.skip_end() then
				return skip(33)
			end
			return part2()
		end
		if at <= 33 then
			helper_efffcfbb(4)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.SndSeStop(var0, 0)
		event.StopBgm(0)
		helper_efffcfbb(4)
		if vm.skipping() then
			return skip(34)
		end
		event.LoadBgm(54)
		event.PlayBgm(0)
		event.DelExtMotion(0)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.DeleteChara(35)
		event.DeleteChara(36)
		event.DeleteChara(37)
		event.DeleteChara(38)
		event.DeleteChara(39)
		event.DeleteChara(40)
		event.DeleteChara(41)
		event.LoadMes(0, -1)
		event.SetCharaPos(0, 0.0, 20.58, -160.0)
		event.SetCharaRot(0, 0.0, 3.14, 0.0)
		event.SetMotion(0, "立ち", 4)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 3.14, 10.0)
		event.SetFadeIn(30)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeOut(0)
	event.SetFlag(324, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetProjection(524.9)
	event.StopBgm(0)
	helper_efffcfbb(4)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(49)
	event.PlayBgm(0)
	event.LoadSound(3503)
	var0 = event.SndLoadSound(8, "snd2/sp/sp_006.sound.json") or var0
	var1 = event.SndLoadSound(3503) or var1
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.ChangeDir("event/e300/e324/")
	event.LoadMes(0, 5, "e324_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e324_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e324_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e324_raochao.gltf", "info", 35)
	event.CharaActive(35)
	event.EohSyncChara(2, 35)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e324_houtyou.gltf", "info", 36)
	event.CharaActive(0, 36)
	event.SetReference(35, "hocho", 36)
	event.LoadChara(5, "e324_otama.gltf", "info", 37)
	event.CharaActive(0, 37)
	event.SetReference(35, "otama", 37)
	event.LoadChara(5, "e324_kiseki_syu.gltf", "info", 38)
	event.CharaActive(0, 38)
	event.SetReference(35, "syumai", 38)
	event.LoadChara(5, "e324_cooking.gltf", "info", 39)
	event.CharaActive(0, 39)
	event.EohSyncChara(3, 39)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ChangeDir("")
	event.LoadChara(5, "event/itemget_ev/itemget_ev.gltf", "info", 40)
	event.CharaActive(0, 40)
	event.LoadChara(5, "event/e300/e317/e317_hana.gltf", "info", 41)
	event.CharaActive(1, 41)
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 33)
		event.LoadEquip(5, 0, 4, "info", 33)
		event.LoadEquip(5, 0, 3, "info", 33)
		event.LoadEquip(5, 0, 2, "info", 33, 34)
		event.LoadMotion(5, "event/e300/e324/e324_mints.gltf", "info", 33)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 33)
		event.EohSyncChara(0, 33)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 33)
		event.LoadEquip(5, 1, 4, "info", 33)
		event.LoadEquip(5, 1, 3, "info", 33)
		event.LoadEquip(5, 1, 2, "info", 33, 34)
		event.LoadMotion(5, "event/e300/e324/e324_monica.gltf", "info", 33)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 33)
		event.EohSyncChara(1, 33)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(33)
	event.CharaActive(34)
	event.EohSetPos(0, 10.0, -0.43, 58.0)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohResetDaPosition(0)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetFootSoundId(0, 4)
	event.EohSetPos(1, -10.0, -0.43, 58.0)
	event.EohSetRot(1, 0.0, 0.0, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohResetDaPosition(1)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.EohSetFootSoundId(1, 4)
	event.EohSetPos(2, 0.0, -0.43, 125.0)
	event.EohSetRot(2, 0.0, 3.14, 0.0)
	var3 = event.EohGetFrameStatus(2, "te_l") or var3
	var4 = event.EohGetFrameStatus(2, "te_r") or var4
	var5 = event.EohGetFrameStatus(2, "te_l2") or var5
	var6 = event.EohGetFrameStatus(2, "te_r2") or var6
	event.EohSetFrameStatus(2, "te_l2", 0)
	event.EohSetFrameStatus(2, "te_r2", 0)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "目パチ")
	event.EohSetFootSoundId(2, 2)
	event.SetCharaPos(41, 2.28, 14.68, 101.74)
	event.SetCharaRot(41, 0.0, 0.0, 0.0)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(-38.51, 45.21, 26.78)
	event.CmrsSetRef(2.62, 22.19, 79.84)
	event.SetFadeIn(30)
	event.ObjsSetMotion(2, "アイヤー", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.SetPakuAnim(2, "口パク")
	helper_93d5f4e9(3240010)
	if vm.skipping() then
		return skip(3)
	end
	helper_a1c34b66(2)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(1, "会話", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_93d5f4e9(3240020)
	if vm.skipping() then
		return skip(5)
	end
	helper_a1c34b66(1)
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsSetPos(0.0, 52.14, 156.79)
	event.CmrsSetRef(0.0, 13.26, 82.92)
	event.ObjsSetMotion(2, "うなづく", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.ObjsSeDelay(2, 16)
	event.ObjsSePlay(2, var1, 4)
	event.ObjsSeDelay(2, 20)
	event.ObjsSePlay(2, var1, 4)
	event.SetPakuAnim(2, "口パク")
	helper_93d5f4e9(3240030)
	if vm.skipping() then
		return skip(7)
	end
	event.SetPakuAnim(2, "口パク")
	helper_93d5f4e9(3240035)
	if vm.skipping() then
		return skip(8)
	end
	helper_a1c34b66(2)
	if vm.skipping() then
		return skip(9)
	end
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "口とじ～わらい口")
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "わらい顔")
	event.EohSetTexAnim(0, 1, "通常目～うれし目")
	event.SndSePlay(var1, 5)
	event.ObjsSetMotion(0, "やった！", 6)
	event.ObjsNextMotion(0, "やった！L", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_93d5f4e9(3240040)
	if vm.skipping() then
		return skip(10)
	end
	helper_a1c34b66(0)
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsSetMotion(0, "立ち", 4)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.CharaActive(0, 41)
	event.CmrsSetPos(-2.82, 25.7, 81.47)
	event.CmrsSetRef(-12.59, 44.96, 128.31)
	event.EohSetFrameStatus(2, "te_l", 0)
	event.EohSetFrameStatus(2, "te_r", 0)
	event.EohSetFrameStatus(2, "te_l2", var5)
	event.EohSetFrameStatus(2, "te_r2", var6)
	event.CharaActive(37)
	event.ObjsSetMotion(2, "左手", 6)
	event.ObjsNextMotion(2, "左手L", 4)
	event.ObjsSeDelay(2, 10)
	event.ObjsSePlay(2, var1, 6)
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(12)
	end
	event.CmrsSetPos(2.82, 25.7, 81.47)
	event.CmrsSetRef(12.59, 44.96, 128.31)
	event.CharaActive(36)
	event.ObjsSetMotion(2, "右手", 6)
	event.ObjsNextMotion(2, "右手L", 4)
	event.ObjsSeDelay(2, 10)
	event.ObjsSePlay(2, var1, 7)
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(13)
	end
	event.CmrsSetPos(0.0, 29.75, 60.1)
	event.CmrsSetRef(0.0, 28.86, 127.43)
	event.CmrsMove2(0.0, 29.75, 93.83, 0.0, 28.86, 127.43, 30, 2, 1.0)
	event.SndSePlay(var1, 8)
	helper_10d80545()
	if vm.skipping() then
		return skip(14)
	end
	helper_efffcfbb(10)
	if vm.skipping() then
		return skip(15)
	end
	event.CmrsSetPos(-66.44, 75.24, 16.08)
	event.CmrsSetRef(-7.71, 24.5, 96.67)
	event.SndSePlay(var1, 9)
	event.ObjsSetPos(2, 0.0, -0.43, 140.0)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(2, "猛調理", 4)
	event.ObjsMove2(2, 30.0, -0.43, 140.0, 10, 2, 1.0)
	event.ObjsMove2(2, -10.0, -0.43, 140.0, 10, 2, 1.0)
	event.ObjsMove2(2, 20.0, -0.43, 140.0, 10, 2, 1.0)
	event.ObjsMove2(2, -40.0, -0.43, 140.0, 10, 2, 1.0)
	event.ObjsMove2(2, 30.0, -0.43, 140.0, 10, 2, 1.0)
	event.CharaActive(1, 39)
	event.ObjsSetPos(3, 0.0, -0.43, 140.0)
	event.ObjsSetRot(3, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(3, "猛調理", 4)
	event.ObjsMove2(3, 30.0, -0.43, 140.0, 10, 2, 1.0)
	event.ObjsMove2(3, -10.0, -0.43, 140.0, 10, 2, 1.0)
	event.ObjsMove2(3, 20.0, -0.43, 140.0, 10, 2, 1.0)
	event.ObjsMove2(3, -40.0, -0.43, 140.0, 10, 2, 1.0)
	event.ObjsMove2(3, 30.0, -0.43, 140.0, 10, 2, 1.0)
	helper_efffcfbb(45)
	if vm.skipping() then
		return skip(16)
	end
	event.SetFadeOut(30)
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(17)
	end
	event.CharaActive(0, 39)
	event.CmrsSetPos(-32.96, 36.45, 93.5)
	event.CmrsSetRef(16.4, 24.48, 129.48999)
	event.CharaActive(0, 36)
	event.CharaActive(0, 37)
	event.CharaActive(38)
	event.EohSetFrameStatus(2, "te_l", var3)
	event.EohSetFrameStatus(2, "te_r", var4)
	event.EohSetFrameStatus(2, "te_l2", 0)
	event.EohSetFrameStatus(2, "te_r2", 0)
	event.ObjsSetPos(2, 0.0, -0.43, 145.0)
	event.ObjsSetRot(2, 0.0, 3.14, 0.0)
	event.ObjsMove(2, 0.0, -0.43, 125.0, 30)
	event.ObjsSetMotion(2, "シューマイ歩き", 4)
	event.ObjsMotionDelay(2, 30)
	event.ObjsSetMotion(2, "シューマイ立ち")
	event.SndSePlay(var1, 10)
	event.SetFadeIn(30)
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(18)
	end
	event.SetPakuAnim(2, "口パク")
	helper_93d5f4e9(3240050)
	if vm.skipping() then
		return skip(19)
	end
	event.ObjsSetMotion(2, "立ち", 4)
	event.CmrsSetPos(11.36, 30.89, 103.02)
	event.CmrsSetRef(10.27, 26.02, 57.53)
	event.CmrsMove2(11.14, 29.75, 93.89, 10.27, 26.02, 57.53, 90, 2, 0.3)
	event.SndPauseBgm()
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "わらい顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.DelReference(38)
	if active_chr_no == 0 then
		event.SetReference(0, "item", 38)
	else
		event.SetReference(33, "item", 38)
	end
	event.ObjsSetMotion(0, "シューマイゲット", 4, -1.0, 1)
	event.CharaActive(1, 40)
	event.SetCharaPos(40, 5.78, 34.25, 59.7)
	event.SetCharaRot(40, 0.0, 0.12, 0.0)
	event.SetMotion(40, "発動", 6)
	helper_efffcfbb(2)
	if vm.skipping() then
		return skip(20)
	end
	event.SndSePlay(var0, 0)
	helper_efffcfbb(120)
	if vm.skipping() then
		return skip(21)
	end
	event.SndSePlay(var1, 11)
	helper_b527b7d3(364, 1)
	if vm.skipping() then
		return skip(22)
	end
	event.CharaActive(0, 38)
	event.PlayBgm(0)
	event.CmrsSetPos(-35.98, 52.37, 163.43)
	event.CmrsSetRef(1.37, 14.33, 85.1)
	event.ObjsSetMotion(0, "右向く会話", 6, -1.0, 1)
	event.ObjsNextMotion(0, "右向くL", 4)
	event.ObjsMotionDelay(1, 6)
	event.ObjsSetMotion(1, "左向く", 6, -1.0, 1)
	event.ObjsNextMotion(1, "左向くL", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_93d5f4e9(3240060)
	if vm.skipping() then
		return skip(23)
	end
	helper_a1c34b66(1)
	if vm.skipping() then
		return skip(24)
	end
	event.ObjsSetMotion(1, "左向くうなづき", 6)
	event.ObjsNextMotion(1, "左向く戻り", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_93d5f4e9(3240070)
	if vm.skipping() then
		return skip(25)
	end
	helper_a1c34b66(1)
	if vm.skipping() then
		return skip(26)
	end
	event.ObjsSetMotion(1, "おじぎ", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	event.ObjsSeDelay(1, 14)
	event.ObjsSePlay(1, var1, 12)
	event.ObjsMotionDelay(0, 6)
	event.ObjsSetMotion(0, "右向く戻り", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_93d5f4e9(3240075)
	if vm.skipping() then
		return skip(27)
	end
	helper_a1c34b66(0)
	if vm.skipping() then
		return skip(28)
	end
	event.ObjsSetMotion(0, "おじぎ", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.ObjsSeDelay(0, 10)
	event.ObjsSePlay(0, var1, 13)
	event.SetPakuAnim(0, "わらい口パク")
	helper_93d5f4e9(3240080)
	if vm.skipping() then
		return skip(29)
	end
	event.ObjsSetMotion(2, "うなづく", 2)
	event.ObjsNextMotion(2, "立ち", 4)
	helper_a1c34b66(2)
	if vm.skipping() then
		return skip(30)
	end
	event.CmrsSetPos(39.03, 40.08, 183.4)
	event.CmrsSetRef(2.76, 28.44, 78.56)
	event.ObjsSetMotion(2, "手を振る", 4)
	event.ObjsSetMotion(0, "走り")
	event.ObjsRotation(0, 0.0, 3.14, 0.0, 10)
	event.ObjsMove(0, 10.0, 0.0, -70.0, 70, 1)
	event.ObjsMove(0, 10.0, 20.58, -160.0, 60, 1)
	event.ObjsSetMotion(1, "走り")
	event.ObjsRotation(1, 0.0, 3.14, 0.0, 10)
	event.ObjsMove(1, -10.0, 0.0, -70.0, 70, 1)
	event.ObjsMove(1, -10.0, 20.58, -160.0, 60, 1)
	event.SetPakuAnim(2, "口パク")
	helper_a348cd1a(3240090, 90)
	if vm.skipping() then
		return skip(31)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_efffcfbb(30)
	if vm.skipping() then
		return skip(32)
	end
	return part2()
end

--- Helper function.
local function helper_1c428()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var0 = helper_befc1874(0, -1, 5, 256, 208, var0)
		end
		return 1
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 1)
	event.SetMesShippo(0, 0)
	event.MesMake_2(
		0,
		"Vamos a darle una Flor del viento\npara que nos haga un Plato milagroso.\n(Pulsa el bot[UNI00f3]n (#) para abrir el men[UNI00fa].)"
	)
	var0 = helper_befc1874(0, -1, 5, 256, 208, var0)
	if vm.skipping() then
		return skip(2)
	end
	if var0 == 1 then
		return 1
	else
		return 0
	end
end

--- Helper function.
local function helper_1c7dc()
	local active_chr_no: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			return
		end
		if at <= 3 then
			helper_a1c34b66(0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.LoadMotion(5, "dungeon/chara/c01b_miss.gltf", "info", 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "dungeon/chara/c02a_miss.gltf", "info", 0)
	end
	if active_chr_no == 2 or active_chr_no == 3 then
		if vm.wait() then
			return skip(2)
		end
		event.Finish()
		return
	end
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetMotion(0, "立ち", 4)
	do
		local out1, out2, out3 = event.GetCameraPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.ObjsReference(0, pos_x, pos_y, pos_z, 6)
	helper_a1c34b66(0)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(0, "だめだめ", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	helper_a1c34b66(0)
	if vm.skipping() then
		return skip(4)
	end
	if active_chr_no == 0 or active_chr_no == 1 then
		event.DelExtMotion(0)
	end
	event.Finish()
end

--- Helper function.
local function helper_10c8c()
	local player_chara: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local player_chara_2: s32 = 0
	local var10: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_e84a97e1(0, -1, var1, player_chara, 0)
		end
		if at <= 2 then
			helper_dd5d7f5f(player_chara_2, var16)
		end
		if at <= 3 then
			helper_e84a97e1(0, -1, var1, player_chara_2, 0)
		end
		if at <= 4 then
			helper_b2621100(5)
		end
		if at <= 5 then
			helper_b2621100(27)
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
	event.MesMake_2(0, "Hola.\nQu[UNI00e9] buen tiempo, [UNI00bf]no?")
	var3 = 0
	flag = event.GetFlag(324) or flag
	flag_2 = event.GetFlag(330) or flag_2
	flag_3 = event.GetFlag(372) or flag_3
	flag_4 = event.GetFlag(400) or flag_4
	flag_5 = event.GetFlag(640) or flag_5
	if var2 == 200 then
		if flag_5 == 0 then
			if flag_2 == 0 then
				if flag == 0 then
					event.MesMake_2(
						0,
						"Para preparar un Plato milagroso necesito\nuna Flor del viento, pero no\nme quedan. Lo siento, no puedo hacer nada."
					)
				else
					event.MesMake_2(
						0,
						"[UNI00bf]Has probado ya la\nEmpanadilla milagro? Se desvirt[UNI00fa]a\nal enfriarse, as[UNI00ed] que c[UNI00f3]metela r[UNI00e1]pido."
					)
				end
			else
				event.MesMake_2(
					0,
					"As[UNI00ed] que te ha venido bien la Empanadilla milagro, [UNI00bf]eh?\nMe alegro de saberlo. Oye, [UNI00bf]quieres comer\nalgo antes de marcharte?"
				)
			end
		else
			event.MesMake_2(0, "[UNI00a1]Ah[UNI00ed] va! Ya es casi la hora.\nBueno, pues entonces nada.")
		end
	end
	if var2 == 201 then
		event.MesMake_2(
			0,
			"Cada objeto tiene\nsus propiedades. Algunos te ayudan, otros\ncambian para formar armas...<page>Si experimentas con ellos, podr[UNI00e1]s\nvencer al peor\nenemigo. Pru[UNI00e9]balo todo."
		)
	end
	if var2 == 202 then
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"No me puedo creer que\nel diab[UNI00f3]lico Emperador Griffon destruyera\neste templo...<page>Si el Gran Sabio Crest\nestuviera aqu[UNI00ed]..."
			)
		else
			event.MesMake_2(
				0,
				"Ahora que el Gran Sabio est[UNI00e1]\notra vez con nosotros, no hay nada\nque temer. Ve y enfr[UNI00e9]ntate a Griffon."
			)
		end
	end
	if var2 == 203 then
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"El templo est[UNI00e1] en una\nnoche perpetua porque el poder del\nCristal lunar es mayor por la noche.<page>Utiliza la fuerza del templo\npara crear una zona nocturna."
			)
		else
			event.MesMake_2(
				0,
				"Que Crest el Grande use el poder\nde este Cristal lunar para ver\ntodas las cosas de este mundo.<page>No hay forma de ocultarse\na los ubicuos ojos de Crest."
			)
		end
	end
	if var2 == 204 then
		event.MesMake_2(
			0,
			"Hola. Hay un gran surtido para\nti. Nuestras armas tienen fama\nde ser fuertes y resistentes."
		)
	end
	if var2 == 205 then
		if flag_5 == 0 then
			if flag_4 == 0 then
				event.MesMake_2(
					0,
					"[UNI00a1]Eh! D[UNI00e9]jate de perder el tiempo\ny ens[UNI00e9][UNI00f1]ale\na Griffon qui[UNI00e9]n manda.\nR[UNI00e1]pido."
				)
			else
				event.MesMake_2(
					0,
					"Bueno, aqu[UNI00ed] se acaba mi\nparte. Ahora te toca a ti. Enc[UNI00e1]rgate\nde Griffon, [UNI00bf]vale?<page>Me has salvado. S[UNI00e9] que si alguien\npuede hacer esto, sois vosotros."
				)
			end
		else
			event.MesMake_2(
				0,
				"Parece que se acerca\nel final del viaje. Acaba con Griffon\npor el Maestro y por todos nosotros.<page>Tienes que vencerlo a toda costa.\nCuando caiga Griffon... Crest y\nyo... seremos verdaderos Sabios."
			)
		end
	end
	if var2 == 206 then
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"Aunque el templo haya recuperado\nla normalidad, sin Crest\nes in[UNI00fa]til.<page>S[UNI00f3]lo [UNI00e9]l posee el enorme poder\nastrol[UNI00f3]gico para\nescrutar el mundo entero."
			)
		else
			event.MesMake_2(
				0,
				"Hasta el propio Crest fue una vez\naprendiz de un sabio. Tuvo que\nser un maestro fabuloso..."
			)
		end
	end
	if var2 == 207 then
		if flag == 0 then
			event.MesMake_2(
				0,
				"Aqu[UNI00ed] la comida es de primera.\nSe me hace la boca agua s[UNI00f3]lo de pensar en ella."
			)
		else
			event.MesMake_2(0, "[UNI00a1]Ha preparado el Plato milagroso!\nLao Chao es un chef de los que no hay.")
		end
	end
	if var2 == 208 then
		if flag == 0 then
			event.MesMake_2(
				0,
				"Cuando hayas cenado aqu[UNI00ed],\nnada te sabr[UNI00e1] igual\nde bien. La comida que ponen es incre[UNI00ed]ble."
			)
		else
			event.MesMake_2(0, "[UNI00a1]Guau! Me muero\npor probar las\nEmpanadillas milagro.")
		end
	end
	if var2 == 209 then
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"[UNI00bf]Te parece raro\nel Reloj de estrellas?<page>[UNI00a1]A qui[UNI00e9]n se lo dices! Yo tengo uno\n, pero no me acuerdo nunca de [UNI00e9]l...\nNunca he viajado al pasado."
			)
		else
			event.MesMake_2(
				0,
				"Es estupendo que fuerais\namigos de Crest, el Gran Sabio.<page>Aunque no sab[UNI00ed]a\nque fuerais tan [UNI00ed]ntimos..."
			)
		end
	end
	if var2 == 210 then
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"El Gran Sabio Crest no est[UNI00e1].\n[UNI00bf]D[UNI00f3]nde se habr[UNI00e1] metido...?<page>Sin [UNI00e9]l se nos cae el alma\na los pies."
			)
		else
			event.MesMake_2(
				0,
				"El Gran Crest me dijo una vez:\nEn el pasado, un hombre llamado Gaspar\ntrat[UNI00f3] de destruir este Cristal lunar.<page>Y el gran maestro de Crest\narriesg[UNI00f3] la vida para protegerlo..."
			)
		end
	end
	if var2 == 211 then
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"[UNI00bf]O sea que el Gran Crest ha desaparecido\ncon el Cristal lunar\npara protegerlo?<page>No entiendo nada..."
			)
		else
			event.MesMake_2(
				0,
				"Has visto el enorme poder\nque atesora el Cristal lunar, [UNI00bf]no? Pero\ns[UNI00f3]lo hay una persona que pueda usarlo...<page>Crest, el Gran Sabio...<page>La gente corriente como nosotros\nno puede hacer nada\nparecido."
			)
		end
	end
	if var2 == 212 then
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"[UNI00bf]Ser[UNI00e9]is acaso vosotros...? El Gran Sabio\nCrest me dijo una vez que un d[UNI00ed]a\nvendr[UNI00ed]an un chico y una chica...<page>[UNI00a1]Sab[UNI00ed]a que la profec[UNI00ed]a se cumplir[UNI00ed]a!<page>Pero por desgracia el Gran Sabio\ntambi[UNI00e9]n ha desaparecido."
			)
		else
			event.MesMake_2(
				0,
				"[UNI00bf]Hace 10.000 a[UNI00f1]os?<page>[UNI00bf]Quieres decir que el Laboratorio Lunar puede\nrealizar una proeza\nfuera del alcance del propio Gran Crest?"
			)
		end
	end
	if var2 == 213 then
		event.MesMake_2(
			0,
			"La luna ejerce un poder de\nextra[UNI00f1]os efectos\nsobre todos los seres vivos.<page>El Cristal lunar\nencierra ese poder."
		)
	end
	if var2 == 214 then
		if flag_2 == 0 then
			event.MesMake_2(
				0,
				"Si buscas la mejor\ncomida del mundo, deber[UNI00ed]as pasarte\npor el restaurante Lao Chao.<page>Lo conoces, [UNI00bf]no?"
			)
		else
			event.MesMake_2(
				0,
				"As[UNI00ed] que sois vosotros. El Gran Crest\nme habl[UNI00f3] de vosotros y de c[UNI00f3]mo\nle salvasteis la vida hace mucho tiempo.<page>Nunca hubiera pensado\nque fuerais unos ni[UNI00f1]os..."
			)
		end
	end
	if var3 == 0 then
		helper_52c8e591(var1, -1, 0, 0)
		if vm.skipping() then
			return skip(1)
		end
	end
	if var3 == 1 then
		helper_e84a97e1(0, -1, var1, player_chara, 0)
		if vm.skipping() then
			return skip(2)
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
			var10 = out1 or var10
			var12 = out3 or var12
		end
		do
			local out1, _, out3 = event.GetCharaPos(var1)
			var13 = out1 or var13
			var15 = out3 or var15
		end
		var16 = event.GetRotLookPos(var13 - var10, var15 - var12) or var16
		helper_dd5d7f5f(player_chara_2, var16)
		if vm.skipping() then
			return skip(3)
		end
		event.SetCharaRot(player_chara_2, 0.0, var16, 0.0)
		event.SetMotion(player_chara_2, "立ち")
		helper_e84a97e1(0, -1, var1, player_chara_2, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.ResetCamera(1, 3.1415927)
	end
	event.SetAi(1, var1)
	if var2 == 201 then
		helper_b2621100(5)
		if vm.skipping() then
			return skip(5)
		end
	end
	if var2 == 204 then
		helper_b2621100(27)
		if vm.skipping() then
			return skip(6)
		end
	end
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 99.
script[99] = helper_1ef0d4b2

--- Program 100.
script[100] = function()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		helper_1c720(1)
	end
	helper_1ef0d4b2()
	flag = event.GetFlag(320) or flag
	flag_2 = event.GetFlag(324) or flag_2
	flag_3 = event.GetFlag(364) or flag_3
	helper_1c720(0)
	if flag_3 == 1 then
		if flag == 0 then
			helper_1340c()
			if vm.skipping() then
				return skip(1)
			end
		else
			argc = event.GetItemHaveNum(363) or argc
			if flag_2 == 0 and argc >= 1 then
				event.FuncPointShow("", "syumai", 1)
			end
		end
	end
	helper_1c720(1)
	event.ResetCamera(1, 0.0)
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_1c720(1)
	end
	helper_1c720(0)
	helper_1740c()
	if vm.skipping() then
		return skip(1)
	end
	helper_1c720(1)
end

--- Program 500.
script[500] = function()
	local var0: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_1c428()
		end
		if at <= 2 then
			var0 = 2
		end
		if at <= 3 then
			helper_efffcfbb(30)
		end
		if at <= 4 then
			helper_1c720(0)
			helper_1740c()
			if not vm.skipping() then
				return landing1()
			end
		end
		if at <= 5 then
			helper_1c720(1)
			helper_1c7dc()
		end
	end
	function part2() end
	function landing1()
		helper_1c720(1)
		return part2()
	end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.SetMotion(0, "立ち")
	var0 = event.GetEventData_2(6) or var0
	if var0 == 1 then
		local t0 = helper_1c428()
		if vm.skipping() then
			return skip(2)
		end
		if t0 ~= 0 then
			var0 = 2
		end
	end
	if var0 == 2 then
		event.GotoUseItem(363)
		do
			local skipped = vm.wait()
			var1 = event.DeferredOutput() or var1
			if skipped then
				return skip(3)
			end
		end
		if var1 == 363 then
			event.AddItem(364)
			event.FuncPointShow("", "syumai", 0)
			event.FadeOutBgm(30)
			event.SetFadeOut(30)
			helper_efffcfbb(30)
			if vm.skipping() then
				return skip(4)
			end
			helper_1c720(0)
			helper_1740c()
			if vm.skipping() then
				return skip(5)
			end
			helper_1c720(1)
		elseif var1 > 0 then
			helper_1c7dc()
			if vm.skipping() then
				return skip(6)
			end
		end
	end
	return part2()
end

--- Program 1000.
script[1000] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_10c8c()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 13200.
script[13200] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_1c720(1)
	end
	helper_1c720(0)
	helper_1340c()
	if vm.skipping() then
		return skip(1)
	end
	helper_1c720(1)
end

--- Program 13240.
script[13240] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_1c720(1)
	end
	helper_1c720(0)
	helper_1740c()
	if vm.skipping() then
		return skip(1)
	end
	helper_1c720(1)
end

return script
