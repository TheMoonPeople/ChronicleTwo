--!strict
-- map/f/f03/i04/f03i04_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_07cf3e45 = require("@lib/event/helper_07cf3e45")
local helper_0a0bce6f = require("@lib/event/helper_0a0bce6f")
local helper_2386f745 = require("@lib/event/helper_2386f745")
local helper_42c67f56 = require("@lib/event/helper_42c67f56")
local helper_8349b4fe = require("@lib/event/helper_8349b4fe")
local helper_87aa4a59 = require("@lib/event/helper_87aa4a59")
local helper_99a9b842 = require("@lib/event/helper_99a9b842")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_c1c32f84 = require("@lib/event/helper_c1c32f84")
local helper_daa89e49 = require("@lib/event/helper_daa89e49")
local helper_e5dca676 = require("@lib/event/helper_e5dca676")
local helper_ec30b150 = require("@lib/event/helper_ec30b150")

local global0: s32 = 0
local global1: s32 = 0

--- Helper function.
local function helper_26f68()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 13 then
			if at <= 1 then
				helper_c1c32f84(10)
			end
			if at <= 2 then
				helper_e5dca676()
			end
			if at <= 3 then
				helper_c1c32f84(10)
			end
			if at <= 4 then
				helper_42c67f56(4640010)
			end
			if at <= 5 then
				helper_2386f745(0)
			end
			if at <= 6 then
				helper_42c67f56(4640020)
			end
			if at <= 7 then
				helper_42c67f56(4640030)
			end
			if at <= 8 then
				helper_42c67f56(4640040)
			end
			if at <= 9 then
				helper_2386f745(0)
			end
			if at <= 10 then
				helper_42c67f56(4640050)
			end
			if at <= 11 then
				helper_2386f745(1)
			end
			if at <= 12 then
				helper_c1c32f84(30)
			end
			if vm.skip_end() then
				return skip(14)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.CharaActive(0)
		event.CharaActive(32)
		event.CharaActive(33)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(32)
		event.DeleteChara(33)
		event.LoadMes(0, -1)
		event.ObjsInit(0)
		event.ObjsInit(1)
	end
	helper_0a0bce6f(0, 0)
	event.SetFlag(464, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(4517)
	var0 = event.SndLoadSound(4517) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e400/e464/")
	event.LoadMes(0, 5, "e464_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e464_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e464_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 32)
		event.LoadEquip(5, 0, 4, "info", 32)
		event.LoadEquip(5, 0, 3, "info", 32)
		event.LoadEquip(5, 0, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e400/e464/e464_mints.gltf", "info", 32)
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
		event.LoadMotion(5, "event/e400/e464/e464_monica.gltf", "info", 32)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 32)
		event.EohSyncChara(1, 32)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(32)
	event.CharaActive(33)
	event.EohSetPos(0, -10.0, 311.3, 900.0)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetFootSoundId(0, 6)
	event.EohSetPos(1, 10.0, 311.3, 930.0)
	event.EohSetRot(1, 0.0, 3.14, 0.0)
	event.EohSetFootSoundId(1, 6)
	event.InitDramaScene()
	event.ObjsSetMotion(0, "歩き", 4)
	event.ObjsMotionDelay(0, 60)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsMove(0, -10.0, 311.3, 860.0, 60)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetTexAnim(0, 1, "半口")
	event.ObjsSetMotion(1, "歩き", 4)
	event.ObjsMotionDelay(1, 70)
	event.ObjsSetMotion(1, "立ち")
	event.ObjsMove(1, 10.0, 311.3, 880.0, 70)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.EohSetTexAnim(1, 1, "半口")
	event.CmrsInit()
	event.CmrsSetPos(60.07, 478.33, 724.73)
	event.CmrsSetRef(-18.43, 284.78, 945.51)
	event.CmrsMove2(269.43, 854.64, 236.34, -18.43, 284.78, 945.51, 60, 0, 1.0)
	event.SetFadeIn(30)
	helper_e5dca676()
	if vm.skipping() then
		return skip(1)
	end
	helper_c1c32f84(10)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(31.95, 382.24, 856.16)
	event.CmrsSetRef(-60.53, 354.53, 697.76)
	event.CmrsMove2(31.95, 382.24, 856.16, 88.2, 354.53, 699.39, 60, 0, 1.0)
	helper_e5dca676()
	if vm.skipping() then
		return skip(3)
	end
	helper_c1c32f84(10)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(-17.13, 313.76, 810.95)
	event.CmrsSetRef(-0.61, 327.72, 860.29)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.ObjsSetMotion(0, "すごい！", 6)
	event.ObjsNextMotion(0, "すごい！L", 4)
	event.ObjsSeDelay(0, 10)
	event.ObjsSePlay(0, var0, 0)
	event.SetPakuAnim(0, "わらい口パク")
	helper_42c67f56(4640010)
	if vm.skipping() then
		return skip(5)
	end
	helper_2386f745(0)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(1, "歩き")
	event.ObjsMotionDelay(1, 30)
	event.ObjsSetMotion(1, "立ち")
	event.ObjsMove(1, 10.0, 311.3, 860.0, 30)
	event.SetPakuAnim(1, "わらい口パク")
	helper_42c67f56(4640020)
	if vm.skipping() then
		return skip(7)
	end
	event.SetPakuAnim(1, "わらい口パク")
	helper_42c67f56(4640030)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsSetMotion(0, "すごい！戻り", 6)
	event.ObjsNextMotion(0, "右向くL", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_42c67f56(4640040)
	if vm.skipping() then
		return skip(9)
	end
	helper_2386f745(0)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsSetMotion(1, "左向く", 6)
	event.ObjsNextMotion(1, "左向くL", 4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_42c67f56(4640050)
	if vm.skipping() then
		return skip(11)
	end
	helper_2386f745(1)
	if vm.skipping() then
		return skip(12)
	end
	event.SetFadeOut(30)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(13)
	end
	return part2()
end

--- Helper function.
local function helper_143c8()
	local active_chr_no: s32 = 0
	local block: s32 = 0
	local block_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		global0 = 0
		global1 = 32
		global0 = 32
		global1 = 0
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e400/e448/e448_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e400/e448/e448_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
		event.CharaActive(1, 37)
	end
	if active_chr_no == 1 then
		global0 = 32
		global1 = 0
		event.LoadChara(5, "chara/c01_base.gltf", "info", global0)
		event.LoadEquip(5, 0, 4, "info", global0)
		event.LoadEquip(5, 0, 3, "info", global0)
		event.LoadEquip(5, 0, 2, "info", global0, 37)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e400/e448/e448_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e400/e448/e448_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.LoadChara(5, "event/e400/e448/e448_chap.gltf", "info", 38)
	event.CharaActive(0, 38)
	event.EohSyncChara(2, 38)
	event.ObjsInit(2, 38)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "event/e400/e448/e448_eina_holo.gltf", "info", 39)
	event.CharaActive(0, 39)
	event.EohSyncChara(3, 39)
	event.ObjsInit(3, 39)
	event.ObjsSyncObj(3, 3)
	event.LoadChara(5, "event/e400/e448/e448_mago.gltf", "info", 40)
	event.CharaActive(0, 40)
	event.EohSyncChara(7, 40)
	event.ObjsInit(7, 40)
	event.ObjsSyncObj(7, 7)
	event.LoadChara(5, "event/e400/e448/e448_lunaken.gltf", "info", 41)
	event.CharaActive(0, 41)
	event.EohSyncChara(8, 41)
	event.ObjsInit(8, 41)
	event.ObjsSyncObj(8, 8)
	event.LoadChara(5, "event/e400/e448/e448_hologram.gltf", "info", 42)
	event.CharaActive(0, 42)
	event.EohSyncObj(4, "p07_f03i04", "f03i04_07-m")
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.EohSyncObj(5, "p08_f03i04", "f03i04_08-m")
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.EohSyncObj(6, "p05_f03i04", "f03i04_05-m")
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	block = event.LoadImg_4(5, "textures/event/e400/e448/e448a.json", 0) or block
	block_2 = event.LoadImg_4(5, "textures/event/e400/e448/e448b.json", 1) or block_2
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e44801", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 416)
	event.SpriteSetPutsize(0, 512, 416)
	event.SpriteSetPos(0, 256, 208)
	event.SpriteSetDraw(0, 0)
	event.EohSyncSprite(10, 0)
	event.ObjsInit(10)
	event.ObjsSyncObj(10, 10)
	event.SpriteInit(1)
	event.SpriteSetType(1, 0)
	event.SpriteSetTexture(1, "e44802", block)
	event.SpriteSetColor(1, 128, 128, 128, 0)
	event.SpriteSetUvsize(1, 0, 0, 512, 416)
	event.SpriteSetPutsize(1, 512, 416)
	event.SpriteSetPos(1, 256, 208)
	event.SpriteSetDraw(1, 0)
	event.EohSyncSprite(11, 1)
	event.ObjsInit(11)
	event.ObjsSyncObj(11, 11)
	event.SpriteInit(2)
	event.SpriteSetType(2, 0)
	event.SpriteSetTexture(2, "e44803", block)
	event.SpriteSetColor(2, 128, 128, 128, 0)
	event.SpriteSetUvsize(2, 0, 0, 512, 416)
	event.SpriteSetPutsize(2, 512, 416)
	event.SpriteSetPos(2, 256, 208)
	event.SpriteSetDraw(2, 0)
	event.EohSyncSprite(12, 2)
	event.ObjsInit(12)
	event.ObjsSyncObj(12, 12)
	event.SpriteInit(3)
	event.SpriteSetType(3, 0)
	event.SpriteSetTexture(3, "e44804", block)
	event.SpriteSetColor(3, 128, 128, 128, 0)
	event.SpriteSetUvsize(3, 0, 0, 512.0, 416.0)
	event.SpriteSetPutsize(3, 512, 416)
	event.SpriteSetPos(3, 256, 208)
	event.SpriteSetDraw(3, 0)
	event.EohSyncSprite(13, 3)
	event.ObjsInit(13)
	event.ObjsSyncObj(13, 13)
	event.SpriteInit(4)
	event.SpriteSetType(4, 0)
	event.SpriteSetTexture(4, "e44805", block_2)
	event.SpriteSetColor(4, 128, 128, 128, 0)
	event.SpriteSetUvsize(4, 0, 0, 512.0, 416.0)
	event.SpriteSetPutsize(4, 512, 416)
	event.SpriteSetPos(4, 256, 208)
	event.SpriteSetDraw(4, 0)
	event.EohSyncSprite(14, 4)
	event.ObjsInit(14)
	event.ObjsSyncObj(14, 14)
	event.SpriteInit(5)
	event.SpriteSetType(5, 0)
	event.SpriteSetTexture(5, "e44806", block_2)
	event.SpriteSetColor(5, 128, 128, 128, 0)
	event.SpriteSetUvsize(5, 0, 0, 512.0, 416.0)
	event.SpriteSetPutsize(5, 512, 416)
	event.SpriteSetPos(5, 256, 208)
	event.SpriteSetDraw(5, 0)
	event.EohSyncSprite(15, 5)
	event.ObjsInit(15)
	event.ObjsSyncObj(15, 15)
	event.SpriteInit(6)
	event.SpriteSetType(6, 0)
	event.SpriteSetTexture(6, "e44807", block_2)
	event.SpriteSetColor(6, 128, 128, 128, 0)
	event.SpriteSetUvsize(6, 0, 0, 512.0, 416.0)
	event.SpriteSetPutsize(6, 512, 416)
	event.SpriteSetPos(6, 256, 208)
	event.SpriteSetDraw(6, 0)
	event.EohSyncSprite(16, 6)
	event.ObjsInit(16)
	event.ObjsSyncObj(16, 16)
	event.LoadMes(0, 5, "event/e400/e448/e448_1.txt")
end

--- Helper function.
local function helper_13e7c()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.CharaActive(1, global0)
		event.CharaActive(0, global1)
		event.DelExtMotion(global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global1)
		event.DeleteChara(37)
	end
	if active_chr_no == 1 then
		event.CharaActive(1, global1)
		event.CharaActive(0, global0)
		event.DelExtMotion(global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global0)
		event.DeleteChara(37)
	end
	event.DeleteChara(38)
	event.DeleteChara(39)
	event.DeleteChara(40)
	event.DeleteChara(41)
	event.DeleteChara(42)
	event.DelImg(0)
	event.SetStatus(1, 0, 256, 0)
	event.EohSetScale(4, 1.0, 1.0, 1.0)
	event.EohSetShow(4, 0)
	event.EohSetShow(6, 0)
	event.ObjsSetPos(5, -1.49967, 492.015, 522.796)
	event.MapJump(-1, "s09", 500)
end

--- Helper function.
local function helper_16a78()
	local var6: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 223 then
			if at <= 1 then
				helper_c1c32f84(30)
			end
			if at <= 2 then
				helper_143c8()
				helper_c1c32f84(4)
			end
			if at <= 3 then
				helper_c1c32f84(150)
			end
			if at <= 4 then
				helper_07cf3e45(4480010, 150)
			end
			if at <= 5 then
				helper_07cf3e45(4480015, -1)
			end
			if at <= 6 then
				helper_c1c32f84(30)
			end
			if at <= 7 then
				helper_42c67f56(4480020)
			end
			if at <= 8 then
				helper_42c67f56(4480030)
			end
			if at <= 9 then
				helper_42c67f56(4480040)
			end
			if at <= 10 then
				helper_c1c32f84(30)
			end
			if at <= 11 then
				helper_c1c32f84(90)
			end
			if at <= 12 then
				helper_c1c32f84(30)
			end
			if at <= 13 then
				helper_c1c32f84(60)
			end
			if at <= 14 then
				helper_42c67f56(4480050)
			end
			if at <= 15 then
				helper_42c67f56(4480060)
			end
			if at <= 16 then
				helper_42c67f56(4480065)
			end
			if at <= 17 then
				helper_c1c32f84(15)
			end
			if at <= 18 then
				helper_42c67f56(4480070)
			end
			if at <= 19 then
				helper_c1c32f84(30)
			end
			if at <= 20 then
				helper_42c67f56(4480080)
			end
			if at <= 21 then
				helper_42c67f56(4480090)
			end
			if at <= 22 then
				helper_2386f745(2)
			end
			if at <= 23 then
				helper_c1c32f84(15)
			end
			if at <= 24 then
				helper_42c67f56(4480095)
			end
			if at <= 25 then
				helper_c1c32f84(30)
			end
			if at <= 26 then
				helper_2386f745(7)
			end
			if at <= 27 then
				helper_2386f745(7)
			end
			if at <= 28 then
				helper_42c67f56(4480100)
			end
			if at <= 29 then
				helper_42c67f56(4480110)
			end
			if at <= 30 then
				helper_42c67f56(4480120)
			end
			if at <= 31 then
				helper_c1c32f84(15)
			end
			if at <= 32 then
				helper_42c67f56(4480130)
			end
			if at <= 33 then
				helper_c1c32f84(15)
			end
			if at <= 34 then
				helper_42c67f56(4480140)
			end
			if at <= 35 then
				helper_42c67f56(4480150)
			end
			if at <= 36 then
				helper_42c67f56(4480155)
			end
			if at <= 37 then
				helper_c1c32f84(30)
			end
			if at <= 38 then
				helper_42c67f56(4480160)
			end
			if at <= 39 then
				helper_07cf3e45(4480170, -1)
			end
			if at <= 40 then
				helper_07cf3e45(4480180, -1)
			end
			if at <= 41 then
				helper_07cf3e45(4480183, -1)
			end
			if at <= 42 then
				helper_e5dca676()
			end
			if at <= 43 then
				helper_42c67f56(4480185)
			end
			if at <= 44 then
				helper_42c67f56(4480188)
			end
			if at <= 45 then
				helper_42c67f56(4480190)
			end
			if at <= 46 then
				helper_c1c32f84(30)
			end
			if at <= 47 then
				helper_42c67f56(4480200)
			end
			if at <= 48 then
				helper_c1c32f84(15)
			end
			if at <= 49 then
				helper_07cf3e45(4480210, -1)
			end
			if at <= 50 then
				helper_c1c32f84(15)
			end
			if at <= 51 then
				helper_42c67f56(4480220)
			end
			if at <= 52 then
				helper_c1c32f84(30)
			end
			if at <= 53 then
				helper_42c67f56(4480230)
			end
			if at <= 54 then
				helper_c1c32f84(30)
			end
			if at <= 55 then
				helper_42c67f56(4480240)
			end
			if at <= 56 then
				helper_c1c32f84(30)
			end
			if at <= 57 then
				helper_42c67f56(4480250)
			end
			if at <= 58 then
				helper_42c67f56(4480260)
			end
			if at <= 59 then
				helper_42c67f56(4480270)
			end
			if at <= 60 then
				helper_42c67f56(4480275)
			end
			if at <= 61 then
				helper_c1c32f84(30)
			end
			if at <= 62 then
				helper_42c67f56(4480280)
			end
			if at <= 63 then
				helper_42c67f56(4480290)
			end
			if at <= 64 then
				helper_42c67f56(4480300)
			end
			if at <= 65 then
				helper_c1c32f84(30)
			end
			if at <= 66 then
				helper_42c67f56(4480310)
			end
			if at <= 67 then
				helper_c1c32f84(30)
			end
			if at <= 68 then
				helper_42c67f56(4480320)
			end
			if at <= 69 then
				helper_c1c32f84(30)
			end
			if at <= 70 then
				helper_42c67f56(4480330)
			end
			if at <= 71 then
				helper_42c67f56(4480340)
			end
			if at <= 72 then
				helper_42c67f56(4480350)
			end
			if at <= 73 then
				helper_c1c32f84(30)
			end
			if at <= 74 then
				helper_c1c32f84(30)
			end
			if at <= 75 then
				helper_42c67f56(4480360)
			end
			if at <= 76 then
				helper_2386f745(8)
			end
			if at <= 77 then
				helper_42c67f56(4480365)
			end
			if at <= 78 then
				helper_c1c32f84(30)
			end
			if at <= 79 then
				helper_42c67f56(4480370)
			end
			if at <= 80 then
				helper_c1c32f84(30)
			end
			if at <= 81 then
				helper_42c67f56(4480380)
			end
			if at <= 82 then
				helper_c1c32f84(15)
			end
			if at <= 83 then
				helper_c1c32f84(30)
			end
			if at <= 84 then
				helper_2386f745(8)
			end
			if at <= 85 then
				helper_2386f745(7)
			end
			if at <= 86 then
				helper_42c67f56(4480390)
			end
			if at <= 87 then
				helper_07cf3e45(4480400, -1)
			end
			if at <= 88 then
				helper_07cf3e45(4480410, -1)
			end
			if at <= 89 then
				helper_c1c32f84(30)
			end
			if at <= 90 then
				helper_c1c32f84(30)
			end
			if at <= 91 then
				helper_c1c32f84(30)
			end
			if at <= 92 then
				helper_c1c32f84(30)
			end
			if at <= 93 then
				helper_e5dca676()
			end
			if at <= 94 then
				helper_c1c32f84(30)
			end
			if at <= 95 then
				helper_c1c32f84(60)
			end
			if at <= 96 then
				helper_42c67f56(4480420)
			end
			if at <= 97 then
				helper_c1c32f84(15)
			end
			if at <= 98 then
				helper_42c67f56(4480430)
			end
			if at <= 99 then
				helper_c1c32f84(15)
			end
			if at <= 100 then
				helper_42c67f56(4480440)
			end
			if at <= 101 then
				helper_c1c32f84(15)
			end
			if at <= 102 then
				helper_42c67f56(4480450)
			end
			if at <= 103 then
				helper_c1c32f84(15)
			end
			if at <= 104 then
				helper_42c67f56(4480460)
			end
			if at <= 105 then
				helper_42c67f56(4480470)
			end
			if at <= 106 then
				helper_42c67f56(4480480)
			end
			if at <= 107 then
				helper_c1c32f84(30)
			end
			if at <= 108 then
				helper_42c67f56(4480490)
			end
			if at <= 109 then
				helper_42c67f56(4480495)
			end
			if at <= 110 then
				helper_42c67f56(4480500)
			end
			if at <= 111 then
				helper_42c67f56(4480510)
			end
			if at <= 112 then
				helper_42c67f56(4480520)
			end
			if at <= 113 then
				helper_c1c32f84(15)
			end
			if at <= 114 then
				helper_c1c32f84(30)
			end
			if at <= 115 then
				helper_42c67f56(4480530)
			end
			if at <= 116 then
				helper_42c67f56(4480535)
			end
			if at <= 117 then
				helper_c1c32f84(15)
			end
			if at <= 118 then
				helper_42c67f56(4480540)
			end
			if at <= 119 then
				helper_42c67f56(4480550)
			end
			if at <= 120 then
				helper_c1c32f84(15)
			end
			if at <= 121 then
				helper_42c67f56(4480560)
			end
			if at <= 122 then
				helper_c1c32f84(30)
			end
			if at <= 123 then
				helper_42c67f56(4480565)
			end
			if at <= 124 then
				helper_c1c32f84(15)
			end
			if at <= 125 then
				helper_42c67f56(4480570)
			end
			if at <= 126 then
				helper_42c67f56(4480575)
			end
			if at <= 127 then
				helper_c1c32f84(15)
			end
			if at <= 128 then
				helper_42c67f56(4480580)
			end
			if at <= 129 then
				helper_42c67f56(4480590)
			end
			if at <= 130 then
				helper_c1c32f84(15)
			end
			if at <= 131 then
				helper_42c67f56(4480600)
			end
			if at <= 132 then
				helper_42c67f56(4480605)
			end
			if at <= 133 then
				helper_42c67f56(4480610)
			end
			if at <= 134 then
				helper_42c67f56(4480615)
			end
			if at <= 135 then
				helper_42c67f56(4480620)
			end
			if at <= 136 then
				helper_42c67f56(4480630)
			end
			if at <= 137 then
				helper_42c67f56(4480635)
			end
			if at <= 138 then
				helper_42c67f56(4480640)
			end
			if at <= 139 then
				helper_42c67f56(4480645)
			end
			if at <= 140 then
				helper_42c67f56(4480650)
			end
			if at <= 141 then
				helper_42c67f56(4480660)
			end
			if at <= 142 then
				helper_42c67f56(4480665)
			end
			if at <= 143 then
				helper_42c67f56(4480670)
			end
			if at <= 144 then
				helper_42c67f56(4480680)
			end
			if at <= 145 then
				helper_42c67f56(4480690)
			end
			if at <= 146 then
				helper_42c67f56(4480700)
			end
			if at <= 147 then
				helper_42c67f56(4480710)
			end
			if at <= 148 then
				helper_42c67f56(4480720)
			end
			if at <= 149 then
				helper_42c67f56(4480730)
			end
			if at <= 150 then
				helper_42c67f56(4480735)
			end
			if at <= 151 then
				helper_42c67f56(4480740)
			end
			if at <= 152 then
				helper_42c67f56(4480750)
			end
			if at <= 153 then
				helper_42c67f56(4480760)
			end
			if at <= 154 then
				helper_42c67f56(4480770)
			end
			if at <= 155 then
				helper_42c67f56(4480775)
			end
			if at <= 156 then
				helper_42c67f56(4480780)
			end
			if at <= 157 then
				helper_42c67f56(4480790)
			end
			if at <= 158 then
				helper_42c67f56(4480795)
			end
			if at <= 159 then
				helper_42c67f56(4480800)
			end
			if at <= 160 then
				helper_42c67f56(4480805)
			end
			if at <= 161 then
				helper_42c67f56(4480810)
			end
			if at <= 162 then
				helper_42c67f56(4480815)
			end
			if at <= 163 then
				helper_42c67f56(4480820)
			end
			if at <= 164 then
				helper_c1c32f84(60)
			end
			if at <= 165 then
				helper_42c67f56(4480830)
			end
			if at <= 166 then
				helper_42c67f56(4480840)
			end
			if at <= 167 then
				helper_42c67f56(4480850)
			end
			if at <= 168 then
				helper_42c67f56(4480860)
			end
			if at <= 169 then
				helper_42c67f56(4480865)
			end
			if at <= 170 then
				helper_c1c32f84(15)
			end
			if at <= 171 then
				helper_42c67f56(4480870)
			end
			if at <= 172 then
				helper_42c67f56(4480880)
			end
			if at <= 173 then
				helper_c1c32f84(15)
			end
			if at <= 174 then
				helper_42c67f56(4480890)
			end
			if at <= 175 then
				helper_c1c32f84(15)
			end
			if at <= 176 then
				helper_42c67f56(4480900)
			end
			if at <= 177 then
				helper_c1c32f84(15)
			end
			if at <= 178 then
				helper_42c67f56(4480910)
			end
			if at <= 179 then
				helper_42c67f56(4480920)
			end
			if at <= 180 then
				helper_c1c32f84(30)
			end
			if at <= 181 then
				helper_42c67f56(4480930)
			end
			if at <= 182 then
				helper_42c67f56(4480940)
			end
			if at <= 183 then
				helper_42c67f56(4480950)
			end
			if at <= 184 then
				helper_42c67f56(4480955)
			end
			if at <= 185 then
				helper_42c67f56(4480960)
			end
			if at <= 186 then
				helper_c1c32f84(15)
			end
			if at <= 187 then
				helper_c1c32f84(30)
			end
			if at <= 188 then
				helper_c1c32f84(36)
			end
			if at <= 189 then
				helper_42c67f56(4480970)
			end
			if at <= 190 then
				helper_42c67f56(4480980)
			end
			if at <= 191 then
				helper_42c67f56(4480985)
			end
			if at <= 192 then
				helper_42c67f56(4480990)
			end
			if at <= 193 then
				helper_42c67f56(4481000)
			end
			if at <= 194 then
				helper_c1c32f84(30)
			end
			if at <= 195 then
				helper_42c67f56(4481010)
			end
			if at <= 196 then
				helper_42c67f56(4481015)
			end
			if at <= 197 then
				helper_42c67f56(4481020)
			end
			if at <= 198 then
				helper_c1c32f84(15)
			end
			if at <= 199 then
				helper_42c67f56(4481030)
			end
			if at <= 200 then
				helper_42c67f56(4481040)
			end
			if at <= 201 then
				helper_42c67f56(4481045)
			end
			if at <= 202 then
				helper_c1c32f84(30)
			end
			if at <= 203 then
				helper_42c67f56(4481050)
			end
			if at <= 204 then
				helper_42c67f56(4481055)
			end
			if at <= 205 then
				helper_42c67f56(4481060)
			end
			if at <= 206 then
				helper_c1c32f84(15)
			end
			if at <= 207 then
				helper_c1c32f84(60)
			end
			if at <= 208 then
				helper_2386f745(2)
			end
			if at <= 209 then
				helper_2386f745(2)
			end
			if at <= 210 then
				helper_c1c32f84(30)
			end
			if at <= 211 then
				helper_42c67f56(4481070)
			end
			if at <= 212 then
				helper_42c67f56(4481075)
			end
			if at <= 213 then
				helper_c1c32f84(30)
			end
			if at <= 214 then
				helper_42c67f56(4481080)
			end
			if at <= 215 then
				helper_42c67f56(4481090)
			end
			if at <= 216 then
				helper_c1c32f84(15)
			end
			if at <= 217 then
				helper_42c67f56(4481100)
			end
			if at <= 218 then
				helper_42c67f56(4481110)
			end
			if at <= 219 then
				helper_42c67f56(4481115)
			end
			if at <= 220 then
				helper_c1c32f84(30)
			end
			if at <= 221 then
				helper_42c67f56(4481120)
			end
			if at <= 222 then
				helper_c1c32f84(30)
			end
			if vm.skip_end() then
				return skip(224)
			end
			return part2()
		end
		if at <= 224 then
			helper_c1c32f84(35)
		end
		helper_13e7c()
	end
	function part2()
		event.CancelDramaScene()
		event.SetFadeOut(30)
		helper_c1c32f84(35)
		if vm.skipping() then
			return skip(225)
		end
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.BgmLoadCancel()
		helper_13e7c()
		event.ResetCamera(0)
		event.SetFadeIn(30)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(448, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetFadeOut(30)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(2)
	end
	helper_143c8()
	event.SetStatus(1, 0, 256, 1)
	event.StopBgm(0)
	helper_c1c32f84(4)
	if vm.skipping() then
		return skip(3)
	end
	event.LoadBgm(22)
	event.LoadSound(4509)
	var6 = event.SndLoadSound(4509) or var6
	event.InitDramaScene()
	event.EohSetFootSoundId(0, 23)
	event.EohSetFootSoundId(1, 23)
	event.EohSetFootSoundId(2, 23)
	event.EohSetFootSoundId(8, 23)
	event.EohSetFootSoundId(7, 23)
	event.EohSetScale(4, 1.0, 0.0, 1.0)
	event.EohSetShow(4, 1)
	event.EohSetShow(6, 0)
	event.ObjsSetPos(5, -1.49967, 492.015, 522.796)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "目パチ")
	event.ObjsTexAnime(7, 0)
	event.ObjsTexAnime(7, 1, "目パチ")
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CharaActive(1, 38)
	event.CmrsSetPos(-956.31, 276.23, 29.53)
	event.CmrsSetRef(-426.59, 67.29, 6.63)
	event.ObjsSetPos(1, -726.2, 116.62, -12.45)
	event.ObjsSetRot(1, 0.0, 1.52, 0.0)
	event.ObjsSetPos(0, -723.31, 115.39, 15.84)
	event.ObjsSetRot(0, 0.0, 1.52, 0.0)
	event.ObjsSetPos(2, 0.0, 14.67, 0.0)
	event.ObjsSetRot(2, 0.0, -1.52, 0.0)
	event.ObjsSetPos(3, 0.0, 14.67, 0.0)
	event.ObjsSetRot(3, 0.0, 3.13, 0.0)
	event.ObjsSetPos(7, 0.0, 14.67, -342.92)
	event.ObjsSetRot(7, 0.0, 0.0, 0.0)
	event.SetCharaPos(42, 0.0, 14.67, 0.0)
	event.SetCharaRot(42, 0.0, 3.13, 0.0)
	event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
	event.ObjsSetMotion(1, "歩き", 4, -1.0, 1)
	event.ObjsSetMotion(2, "立ち", 4)
	event.ObjsSetMotion(7, "立ち", 4)
	event.ObjsSetMotion(3, "立ち", 4)
	event.ObjsSetMotion(8, "立ち", 4)
	event.ObjsMove(1, -229.42, 14.67, -11.08, 240, 1)
	event.ObjsMove(0, -235.3, 14.67, 16.5, 240, 1)
	event.SetFadeIn(30)
	helper_c1c32f84(150)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(54.63, 25.75, -14.11)
	event.CmrsSetRef(-484.75, 44.7, 19.5)
	event.ObjsSetMotion(2, "立ち会話（やぁ）", 2)
	event.ObjsMotionDelay(2, 90)
	event.ObjsSetMotion(2, "会話", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.CmrsPrdelay(90)
	event.CmrsSetPos(-37.91, 29.85, 18.95)
	event.CmrsSetRef(1.68, 29.5, -0.76)
	event.SetPakuAnim(2, "わらい口パク")
	helper_07cf3e45(4480010, 150)
	if vm.skipping() then
		return skip(5)
	end
	event.ResetPakuAnim()
	helper_07cf3e45(4480015, -1)
	if vm.skipping() then
		return skip(6)
	end
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsTexAnime(1, 1, "口とじ～口あけ")
	event.ObjsSetMotion(2, "立ち", 4)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetPos(1, -37.18, 14.67, -12.31)
	event.ObjsSetRot(1, 0.0, 1.16, 0.0)
	event.ObjsSetPos(0, -34.01, 14.67, 9.43)
	event.ObjsSetRot(0, 0.0, 1.52, 0.0)
	event.CmrsSetPos(57.77, 30.54, 48.68)
	event.CmrsSetRef(-37.13, 36.5, -12.63)
	event.ObjsSetMotion(2, "会話", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.SetPakuAnim(2, "わらい口パク")
	helper_42c67f56(4480020)
	if vm.skipping() then
		return skip(8)
	end
	event.ResetPakuAnim()
	event.SndSePlay(var6, 3)
	event.ObjsSetMotion(0, "ホント！！", 6)
	event.ObjsNextMotion(0, "ホント！！L")
	event.SetPakuAnim(0, "わらい口パク")
	helper_42c67f56(4480030)
	if vm.skipping() then
		return skip(9)
	end
	event.ResetPakuAnim()
	event.CmrsSetPos(-29.05, 30.34, 16.9)
	event.CmrsSetRef(16.79, 33.58, -8.54)
	event.ObjsSetMotion(2, "会話", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.SetPakuAnim(2, "わらい口パク")
	helper_42c67f56(4480040)
	if vm.skipping() then
		return skip(10)
	end
	event.ResetPakuAnim()
	event.PlayBgm(0)
	event.ObjsSetMotion(2, "指パッチンin", 2)
	event.ObjsNextMotion(2, "指パッチンループ")
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(-239.44, 156.02, -52.82)
	event.CmrsSetRef(-191.28, 200.5, 65.31)
	event.SndSePlay(var6, 4)
	event.ObjsSetScale(4, 1.0, 1.0, 1.0, 90)
	event.ObjsMove(5, -1.49967, 300.0, 522.796, 90)
	helper_c1c32f84(90)
	if vm.skipping() then
		return skip(12)
	end
	event.CmrsSetPos(5.53, 370.96, 183.63)
	event.CmrsSetRef(4.24, 381.19, 324.61)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(13)
	end
	event.EohSetScale(6, 1.0, 0.0, 1.0)
	event.EohSetShow(6, 1)
	event.ObjsSetScale(6, 1.0, 1.0, 1.0, 30)
	event.SndSePlay(var6, 5)
	helper_c1c32f84(60)
	if vm.skipping() then
		return skip(14)
	end
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.CmrsSetPos(0.0, 16.85, -78.07)
	event.CmrsSetRef(0.0, 87.26, 92.04)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsSetPos(1, -25.0, 14.67, 0.0)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.ObjsSetPos(0, 25.0, 14.67, 0.0)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.ObjsResetDaPosition(1)
	event.ObjsResetDaPosition(0)
	event.ObjsSetMotion(2, "立ち", 4)
	event.ObjsSetMotion(0, "のけぞる", 6, -1, 1)
	event.ObjsNextMotion(0, "のけぞるL")
	event.ObjsSetMotion(1, "上向くL", 4, -1, 1)
	helper_42c67f56(4480050)
	if vm.skipping() then
		return skip(15)
	end
	event.ObjsSetMotion(2, "会話（見上げ）", 6)
	event.ObjsNextMotion(2, "立ち（見上げ）", 4)
	event.SetPakuAnim(2, "わらい口パク")
	helper_42c67f56(4480060)
	if vm.skipping() then
		return skip(16)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(2, "会話（見上げ）", 6)
	event.ObjsNextMotion(2, "立ち（見上げ）", 4)
	event.SetPakuAnim(2, "わらい口パク")
	helper_42c67f56(4480065)
	if vm.skipping() then
		return skip(17)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(2, "立ち", 2)
	helper_c1c32f84(15)
	if vm.skipping() then
		return skip(18)
	end
	event.CharaActive(0, global0)
	event.CmrsSetPos(36.52, 23.74, -2.78)
	event.CmrsSetRef(-80.76, 43.28, 5.58)
	event.ObjsSetMotion(2, "会話（見上げ）", 6)
	event.ObjsNextMotion(2, "立ち（見上げ）", 4)
	event.SetPakuAnim(2, "わらい口パク")
	helper_42c67f56(4480070)
	if vm.skipping() then
		return skip(19)
	end
	event.ResetPakuAnim()
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(20)
	end
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おどろき顔")
	event.ObjsTexAnime(1, 1, "おどろき目パチ")
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "うれし顔")
	event.ObjsTexAnime(0, 1, "うれし目パチ")
	event.CharaActive(1, global0)
	event.CmrsSetPos(7.12, 87.39, 72.51)
	event.CmrsSetRef(0.52, 31.03, 7.67)
	event.SndSePlay(var6, 6)
	event.ObjsSetMotion(0, "すごいよ！", 6)
	event.ObjsNextMotion(0, "すごいよ！L")
	event.SetPakuAnim(0, "わらい口パク")
	helper_42c67f56(4480080)
	if vm.skipping() then
		return skip(21)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(0, "チャップを見る", 2)
	event.ObjsNextMotion(0, "チャップを見るL")
	event.ObjsSetMotion(2, "会話（見上げ）", 6)
	event.ObjsNextMotion(2, "立ち（見上げ）", 4)
	event.SetPakuAnim(2, "わらい口パク")
	helper_42c67f56(4480090)
	if vm.skipping() then
		return skip(22)
	end
	event.ResetPakuAnim()
	event.SndSePlay(var6, 7)
	event.ObjsSetMotion(2, "振り向く")
	event.ObjsRotation(2, 0.0, -3.1, 0.0, 30)
	helper_2386f745(2)
	if vm.skipping() then
		return skip(23)
	end
	event.ObjsSetMotion(2, "立ち")
	helper_c1c32f84(15)
	if vm.skipping() then
		return skip(24)
	end
	helper_42c67f56(4480095)
	if vm.skipping() then
		return skip(25)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "うれし顔")
	event.ObjsTexAnime(0, 1, "うれし目～通常目")
	event.SndSePlay(var6, 8)
	event.ObjsSetMotion(1, "左向く", 2, 0.5)
	event.ObjsNextMotion(1, "左向くL")
	event.CharaActive(1, 40)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(26)
	end
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsSetRot(1, 0.0, 2.94, 0.0)
	event.ObjsSetRot(0, 0.0, -2.74, 0.0)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetMotion(0, "立ち", 4)
	event.CmrsSetPos(196.02, 29.8, -218.1)
	event.CmrsSetRef(0.0, 27.27, -342.92)
	event.ObjsSetMotion(7, "歩き", 4)
	event.ObjsMove(7, 0.0, 14.67, -111.07, 180)
	event.CmrsMoveRef(0.0, 27.27, -111.07, 180)
	helper_2386f745(7)
	if vm.skipping() then
		return skip(27)
	end
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.ObjsSetPos(7, 0.0, 14.67, -100.0)
	event.ObjsMove(7, 0.0, 14.67, -86.5, 30)
	event.CmrsSetPos(-41.41, 39.04, -154.86)
	event.CmrsSetRef(-12.51, 37.54, -79.79)
	helper_2386f745(7)
	if vm.skipping() then
		return skip(28)
	end
	event.ObjsSetMotion(7, "立ち")
	event.ObjsSetMotion(0, "ジャミング！？", 2)
	event.ObjsNextMotion(0, "ジャミング！？L")
	event.ObjsSetMotion(1, "身構え", 2)
	event.ObjsNextMotion(1, "身構えL")
	event.SndSePlay(var6, 9)
	event.SetPakuAnim(1, "通常口パク")
	helper_42c67f56(4480100)
	if vm.skipping() then
		return skip(29)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(0, "通常口パク")
	helper_42c67f56(4480110)
	if vm.skipping() then
		return skip(30)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(2, "ユリス向くin", 2)
	event.ObjsNextMotion(2, "ユリス向く（会話）", 2)
	event.ObjsNextMotion(2, "ユリス向くループ")
	event.SetPakuAnim(2, "通常口パク")
	helper_42c67f56(4480120)
	if vm.skipping() then
		return skip(31)
	end
	event.ResetPakuAnim()
	helper_c1c32f84(15)
	if vm.skipping() then
		return skip(32)
	end
	event.CmrsSetPos(-20.2, 39.04, -21.57)
	event.CmrsSetRef(0.05, 37.54, -82.59)
	helper_42c67f56(4480130)
	if vm.skipping() then
		return skip(33)
	end
	helper_c1c32f84(15)
	if vm.skipping() then
		return skip(34)
	end
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.CmrsSetPos(-41.41, 39.04, -154.86)
	event.CmrsSetRef(-12.51, 37.54, -79.79)
	event.ObjsSetMotion(2, "立ち")
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetMotion(1, "身構え戻り", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_42c67f56(4480140)
	if vm.skipping() then
		return skip(35)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(7, "会話1", 2)
	event.ObjsNextMotion(7, "会話3", 4)
	helper_42c67f56(4480150)
	if vm.skipping() then
		return skip(36)
	end
	event.ObjsSetMotion(7, "会話2", 2)
	event.ObjsNextMotion(7, "会話3", 4)
	helper_42c67f56(4480155)
	if vm.skipping() then
		return skip(37)
	end
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(38)
	end
	event.CmrsSetPos(32.13, 29.73, -45.7)
	event.CmrsSetRef(-1.56, 43.07, -89.26)
	event.ObjsSetMotion(7, "会話1", 2)
	event.ObjsNextMotion(7, "会話3", 4)
	helper_42c67f56(4480160)
	if vm.skipping() then
		return skip(39)
	end
	event.CmrsInitPas()
	event.CmrsSetPasFrm(600)
	event.CmrsAddPas(75.1, 43.14, -309.6, 77.12, 43.07, -89.97)
	event.CmrsAddPas(-81.37, 43.14, -308.16, -79.35, 43.07, -88.53)
	event.CmrsStartPas()
	event.ObjsSetMotion(7, "会話1", 2)
	event.ObjsNextMotion(7, "会話3", 4)
	helper_07cf3e45(4480170, -1)
	if vm.skipping() then
		return skip(40)
	end
	event.ObjsSetMotion(7, "会話2", 2)
	event.ObjsNextMotion(7, "会話3", 4)
	helper_07cf3e45(4480180, -1)
	if vm.skipping() then
		return skip(41)
	end
	event.ObjsSetMotion(7, "会話1", 2)
	event.ObjsNextMotion(7, "会話3", 4)
	helper_07cf3e45(4480183, -1)
	if vm.skipping() then
		return skip(42)
	end
	helper_e5dca676()
	if vm.skipping() then
		return skip(43)
	end
	event.CmrsSetPos(2.97, 138.34, 137.77)
	event.CmrsSetRef(0.19, 43.07, -24.14)
	event.ObjsSetMotion(7, "会話2", 2)
	event.ObjsNextMotion(7, "会話3", 4)
	helper_42c67f56(4480185)
	if vm.skipping() then
		return skip(44)
	end
	event.ObjsSetMotion(7, "会話1", 2)
	event.ObjsNextMotion(7, "会話3", 4)
	helper_42c67f56(4480188)
	if vm.skipping() then
		return skip(45)
	end
	event.ObjsSetMotion(7, "立ち")
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち")
	helper_42c67f56(4480190)
	if vm.skipping() then
		return skip(46)
	end
	event.ObjsSetMotion(7, "うなづく", 2)
	event.ObjsNextMotion(7, "立ち")
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(47)
	end
	event.CmrsSetPos(32.13, 29.73, -45.7)
	event.CmrsSetRef(-1.56, 43.07, -89.26)
	event.ObjsSetMotion(7, "会話1", 2)
	event.ObjsNextMotion(7, "会話3", 4)
	helper_42c67f56(4480200)
	if vm.skipping() then
		return skip(48)
	end
	helper_c1c32f84(15)
	if vm.skipping() then
		return skip(49)
	end
	event.CmrsSetPos(232.26, 353.87, 175.15)
	event.CmrsSetRef(24.92, 388.25, 507.94)
	event.CmrsMove2(205.95, 353.87, 220.9, 24.92, 388.25, 507.94, 400, 2, 1.0)
	helper_07cf3e45(4480210, -1)
	if vm.skipping() then
		return skip(50)
	end
	helper_c1c32f84(15)
	if vm.skipping() then
		return skip(51)
	end
	event.CmrsInit()
	event.CmrsSetPos(60.01, 36.76, -80.17)
	event.CmrsSetRef(-17.73, 44.3, -88.09)
	event.ObjsSetMotion(7, "会話1", 2)
	event.ObjsNextMotion(7, "会話3", 4)
	helper_42c67f56(4480220)
	if vm.skipping() then
		return skip(52)
	end
	event.ObjsSetMotion(7, "立ち")
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(53)
	end
	event.CmrsSetPos(2.97, 138.34, 137.77)
	event.CmrsSetRef(0.19, 43.07, -24.14)
	event.ObjsSetMotion(7, "会話2", 2)
	event.ObjsNextMotion(7, "会話3", 4)
	helper_42c67f56(4480230)
	if vm.skipping() then
		return skip(54)
	end
	event.ObjsSetMotion(7, "立ち")
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(55)
	end
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsTexAnime(1, 1, "半口")
	event.ObjsSetPos(1, -17.0, 14.67, 0.0)
	event.ObjsSetRot(1, 0.0, 2.94, 0.0)
	event.ObjsSetPos(0, 17.0, 14.67, 0.0)
	event.ObjsSetRot(0, 0.0, -2.74, 0.0)
	event.ObjsResetDaPosition(1)
	event.ObjsResetDaPosition(0)
	event.CmrsSetPos(-39.51, 33.29, -31.48)
	event.CmrsSetRef(2.52, 33.3, 2.35)
	event.SetPakuAnim(0, "通常口パク")
	helper_42c67f56(4480240)
	if vm.skipping() then
		return skip(56)
	end
	event.ResetPakuAnim()
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(57)
	end
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsSetPos(1, -25.0, 14.67, 0.0)
	event.ObjsSetRot(1, 0.0, 2.94, 0.0)
	event.ObjsSetPos(0, 25.0, 14.67, 0.0)
	event.ObjsSetRot(0, 0.0, -2.74, 0.0)
	event.ObjsResetDaPosition(1)
	event.ObjsResetDaPosition(0)
	event.CmrsSetPos(-0.1, 86.08, -136.54)
	event.CmrsSetRef(-1.59, -2.29, 3.25)
	event.ObjsSetMotion(1, "考え", 2)
	event.ObjsNextMotion(1, "考えL")
	event.ObjsSetMotion(7, "会話1", 2)
	event.ObjsNextMotion(7, "会話3", 4)
	helper_42c67f56(4480250)
	if vm.skipping() then
		return skip(58)
	end
	event.ObjsSetMotion(7, "立ち")
	event.ObjsSetMotion(0, "いや、そんな・・・", 2)
	event.ObjsNextMotion(0, "立ち", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_42c67f56(4480260)
	if vm.skipping() then
		return skip(59)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "顔上げ", 2)
	event.ObjsNextMotion(1, "顔上げ会話")
	event.SetPakuAnim(1, "通常口パク")
	helper_42c67f56(4480270)
	if vm.skipping() then
		return skip(60)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_42c67f56(4480275)
	if vm.skipping() then
		return skip(61)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "考えL")
	event.ObjsSetMotion(0, "左向く", 6)
	event.ObjsNextMotion(0, "左向くL")
	event.ObjsSetMotion(2, "モニカ向くin", 6)
	event.ObjsNextMotion(2, "モニカ向くループ")
	event.ObjsSetMotion(7, "モニカ見る", 6)
	event.ObjsNextMotion(7, "モニカ見るループ")
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(62)
	end
	event.ObjsSetMotion(7, "立ち", 4)
	event.ObjsSetPos(1, -17.0, 14.67, 0.0)
	event.ObjsSetRot(1, 0.0, 2.94, 0.0)
	event.ObjsSetPos(0, 17.0, 14.67, 0.0)
	event.ObjsSetRot(0, 0.0, 3.06, 0.0)
	event.ObjsResetDaPosition(1)
	event.ObjsResetDaPosition(0)
	event.CmrsSetPos(-39.51, 33.29, -31.48)
	event.CmrsSetRef(2.52, 33.3, 2.35)
	event.ObjsSetMotion(1, "顔上げ", 2)
	event.ObjsNextMotion(1, "顔上げ会話")
	event.SetPakuAnim(1, "通常口パク")
	helper_42c67f56(4480280)
	if vm.skipping() then
		return skip(63)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "考えL")
	event.ObjsSetMotion(0, "左向く会話", 2)
	event.ObjsNextMotion(0, "左向くL")
	event.SetPakuAnim(0, "通常口パク")
	helper_42c67f56(4480290)
	if vm.skipping() then
		return skip(64)
	end
	event.ResetPakuAnim()
	event.SndSePlay(var6, 10)
	event.ObjsSetMotion(1, "右見る", 2)
	event.ObjsNextMotion(1, "右向くL")
	event.ObjsSetMotion(2, "モニカからユリス向く", 2)
	event.ObjsNextMotion(2, "モニカからユリス向くＬ")
	event.SetPakuAnim(1, "通常口パク")
	helper_42c67f56(4480300)
	if vm.skipping() then
		return skip(65)
	end
	event.ResetPakuAnim()
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(66)
	end
	event.ObjsSetPos(1, -25.0, 14.67, 0.0)
	event.ObjsSetRot(1, 0.0, 2.94, 0.0)
	event.ObjsSetPos(0, 25.0, 14.67, 0.0)
	event.ObjsSetRot(0, 0.0, -2.74, 0.0)
	event.ObjsResetDaPosition(1)
	event.ObjsResetDaPosition(0)
	event.CmrsSetPos(8.65, 18.02, -25.49)
	event.CmrsSetRef(26.65, 37.13, 2.87)
	event.ObjsSetMotion(0, "左向く会話", 2)
	event.SetPakuAnim(0, "通常口パク")
	helper_42c67f56(4480310)
	if vm.skipping() then
		return skip(67)
	end
	event.ResetPakuAnim()
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(68)
	end
	event.CharaActive(0, 38)
	event.ObjsSetMotion(0, "会話", 6)
	event.CmrsSetPos(-17.5, 31.97, -0.13)
	event.CmrsSetRef(26.39, 34.27, 0.14)
	event.SetPakuAnim(0, "通常口パク")
	helper_42c67f56(4480320)
	if vm.skipping() then
		return skip(69)
	end
	event.ResetPakuAnim()
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(70)
	end
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsTexAnime(1, 1, "半口")
	event.ObjsSetPos(1, -17.0, 14.67, 0.0)
	event.ObjsSetRot(1, 0.0, -3.1, 0.0)
	event.ObjsSetPos(0, 17.0, 14.67, 0.0)
	event.ObjsSetRot(0, 0.0, 3.06, 0.0)
	event.ObjsResetDaPosition(1)
	event.ObjsResetDaPosition(0)
	event.CharaActive(1, 38)
	event.CmrsSetPos(45.32, 50.75, -47.14)
	event.CmrsSetRef(5.0, 37.13, -3.26)
	event.ObjsSetMotion(0, "考えるL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_42c67f56(4480330)
	if vm.skipping() then
		return skip(71)
	end
	event.ResetPakuAnim()
	event.ObjsTexaDelay(0, 120)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目～おどろき目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "通常目～おこり目")
	event.ObjsTexaDelay(1, 30)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	event.ObjsMotionDelay(0, 20)
	event.ObjsSetMotion(0, "モニカを見る", 6)
	event.ObjsNextMotion(0, "左向くL", 4)
	event.ObjsMotionDelay(2, 20)
	event.ObjsSetMotion(2, "ユリスからモニカ向く", 2)
	event.ObjsNextMotion(2, "ユリスからモニカ向くＬ")
	event.ObjsMotionDelay(1, 120)
	event.ObjsSetMotion(1, "怒る入り", 6)
	event.ObjsNextMotion(1, "怒る会話", 2)
	event.ObjsNextMotion(1, "怒る入りL", 4)
	event.SndSePlay(var6, 11)
	event.SetPakuAnim(1, "大口パク")
	helper_42c67f56(4480340)
	if vm.skipping() then
		return skip(72)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(0, "引きうなづき", 6)
	event.ObjsNextMotion(0, "左向くL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_42c67f56(4480350)
	if vm.skipping() then
		return skip(73)
	end
	event.ResetPakuAnim()
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(74)
	end
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsSetMotion(8, "走り", 4)
	event.ObjsSetMotion(1, "右向くL", 4)
	event.ObjsSetMotion(2, "立ち", 2)
	event.CmrsSetPos(-16.75, 163.56, -195.26)
	event.CmrsSetRef(19.55, 31.65, -72.54)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(75)
	end
	event.SetPakuAnim(8, "通常口パク")
	helper_42c67f56(4480360)
	if vm.skipping() then
		return skip(76)
	end
	event.ResetPakuAnim()
	event.FadeOutBgm(30)
	event.ObjsSetMotion(0, "左向く戻り", 6)
	event.ObjsNextMotion(0, "立ち")
	event.ObjsSetMotion(1, "右向く戻り", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.ObjsSetMotion(7, "研究員見る", 6)
	event.ObjsNextMotion(7, "研究員見るL")
	event.ObjsSetRot(8, 0.0, -0.41, 0.0)
	event.CharaActive(1, 41)
	event.ObjsInitPas(8)
	event.ObjsSetPasFrm(8, 50)
	event.ObjsAddPas(8, 81.75, 14.67, -207.27)
	event.ObjsAddPas(8, 49.31, 14.67, -124.97)
	event.ObjsStartPas(8)
	helper_2386f745(8)
	if vm.skipping() then
		return skip(77)
	end
	event.CmrsSetPos(48.18, 36.87, -53.98)
	event.CmrsSetRef(47.39, 31.65, -127.29)
	event.ObjsSetMotion(8, "会話(あせり）", 6)
	event.ObjsNextMotion(8, "立ち(あせり）", 4)
	event.SetPakuAnim(8, "口パク")
	helper_42c67f56(4480365)
	if vm.skipping() then
		return skip(78)
	end
	event.ResetPakuAnim()
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(79)
	end
	event.StopBgm(0)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsSetMotion(8, "立ち", 4)
	event.CmrsSetPos(-16.75, 163.56, -195.26)
	event.CmrsSetRef(19.55, 31.65, -72.54)
	event.ObjsSetMotion(2, "なにin", 2)
	event.ObjsNextMotion(2, "なに（会話）", 2)
	event.ObjsNextMotion(2, "なにループ")
	event.SetPakuAnim(2, "通常口パク")
	helper_42c67f56(4480370)
	if vm.skipping() then
		return skip(80)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(2, "なにループ")
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(81)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目～おどろき目")
	event.ObjsTexAnime(0, 1, "半口")
	event.ObjsSetMotion(2, "立ち", 4)
	event.ObjsSetPos(1, -25.0, 14.67, 0.0)
	event.ObjsSetPos(0, 25.0, 14.67, 0.0)
	event.ObjsResetDaPosition(1)
	event.ObjsResetDaPosition(0)
	event.CmrsSetPos(43.45, 19.19, -25.77)
	event.CmrsSetRef(16.15, 41.45, 12.29)
	helper_42c67f56(4480380)
	if vm.skipping() then
		return skip(82)
	end
	helper_c1c32f84(15)
	if vm.skipping() then
		return skip(83)
	end
	event.CmrsSetPos(28.79, 40.99, 82.7)
	event.CmrsSetRef(27.79, 35.36, -21.36)
	event.ObjsSetMotion(8, "礼", 6)
	event.ObjsNextMotion(8, "立ち")
	event.ObjsSetMotion(7, "礼", 6)
	event.ObjsNextMotion(7, "立ち")
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(84)
	end
	event.ObjsSetMotion(8, "振り返り", 6)
	event.ObjsNextMotion(8, "立ち")
	event.ObjsSetMotion(7, "振り返り", 6)
	event.ObjsNextMotion(7, "立ち")
	event.SndSePlay(var6, 12)
	event.ObjsRotation(8, 0.0, 2.38, 0.0, 30)
	event.ObjsRotation(7, 0.0, 2.38, 0.0, 30)
	helper_2386f745(8)
	if vm.skipping() then
		return skip(85)
	end
	helper_2386f745(7)
	if vm.skipping() then
		return skip(86)
	end
	event.ObjsSetMotion(7, "走り")
	event.ObjsSetMotion(8, "走り")
	event.ObjsMove(8, 256.4, 14.67, -306.5, 120, 1)
	event.ObjsMove(7, 214.08, 14.67, -282.13, 120, 1)
	helper_42c67f56(4480390)
	if vm.skipping() then
		return skip(87)
	end
	event.ObjsSetMotion(8, "立ち", 4)
	event.ObjsSetMotion(7, "立ち", 4)
	event.CharaActive(0, 40)
	event.CharaActive(0, 41)
	event.CmrsInitPas()
	event.CmrsSetPasFrm(480)
	event.CmrsAddPas(-0.11, 39.79, -43.33, 24.6, 36.05, -0.54)
	event.CmrsAddPas(12.71, 39.79, -21.13, 24.6, 36.05, -0.54)
	event.CmrsStartPas()
	event.SetCrossfade(30)
	helper_07cf3e45(4480400, -1)
	if vm.skipping() then
		return skip(88)
	end
	helper_07cf3e45(4480410, -1)
	if vm.skipping() then
		return skip(89)
	end
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(90)
	end
	event.SetFadeOut(30)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(91)
	end
	event.LoadBgm(32)
	event.CmrsInit()
	event.ObjsSetPos(1, 21.0, 14.67, -96.4)
	event.ObjsSetRot(1, 0.0, -0.42, 0.0)
	event.ObjsSetPos(0, -21.0, 14.67, -96.4)
	event.ObjsSetRot(0, 0.0, 0.42, 0.0)
	event.ObjsSetPos(2, 0.0, 14.67, -96.4)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
	event.ObjsSetMotion(2, "立ち", 4)
	event.CmrsSetPos(-0.58, 284.23, -107.49)
	event.CmrsSetRef(-0.45, 364.5, 62.05)
	event.PlayBgm(0)
	event.SetFadeIn(30)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(92)
	end
	event.SndSePlay(var6, 13)
	event.CharaActive(1, 42)
	event.SetMotion(42, "光射出", 6, -1, 1)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(93)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(0, 1, "半口")
	event.CmrsInitPas()
	event.CmrsSetPasFrm(120)
	event.CmrsAddPas(-0.44, 313.67, -237.11, 0.0, 258.09, 0.0)
	event.CmrsAddPas(-0.44, 87.87, -237.11, 0.0, 32.29, 0.0)
	event.CmrsStartPas()
	event.SetMotion(42, "光射出", 6, -1, 1)
	helper_e5dca676()
	if vm.skipping() then
		return skip(94)
	end
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(95)
	end
	event.CmrsSetPos(-31.6, 43.91, -71.47)
	event.CmrsSetRef(0.0, 32.29, 0.0)
	event.SndSePlay(var6, 14)
	event.SetMotion(42, "出現", 2, -1, 1)
	helper_c1c32f84(60)
	if vm.skipping() then
		return skip(96)
	end
	event.SetMotion(42, "立ち", 2, -1, 1)
	event.CharaActive(1, 39)
	event.ObjsSetMotion(3, "会話2")
	event.SetPakuAnim(3, "口パク")
	helper_42c67f56(4480420)
	if vm.skipping() then
		return skip(97)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(3, "立ち")
	helper_c1c32f84(15)
	if vm.skipping() then
		return skip(98)
	end
	event.CmrsSetPos(-26.24, 38.68, 42.72)
	event.CmrsSetRef(-5.44, 38.62, -14.16)
	event.ObjsSetMotion(3, "会話2")
	event.SetPakuAnim(3, "口パク")
	helper_42c67f56(4480430)
	if vm.skipping() then
		return skip(99)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(3, "立ち")
	helper_c1c32f84(15)
	if vm.skipping() then
		return skip(100)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "おどろき目パチ")
	event.CmrsSetPos(-36.23, 32.89, -39.54)
	event.CmrsSetRef(-20.39, 30.89, -98.66)
	event.SetPakuAnim(0, "通常口パク")
	helper_42c67f56(4480440)
	if vm.skipping() then
		return skip(101)
	end
	event.ResetPakuAnim()
	helper_c1c32f84(15)
	if vm.skipping() then
		return skip(102)
	end
	event.CmrsSetPos(0.93, 19.93, -42.57)
	event.CmrsSetRef(0.16, 32.65, -3.38)
	event.ObjsSetMotion(3, "会話2")
	event.SetPakuAnim(3, "口パク")
	helper_42c67f56(4480450)
	if vm.skipping() then
		return skip(103)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(3, "立ち")
	helper_c1c32f84(15)
	if vm.skipping() then
		return skip(104)
	end
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsSetRot(1, 0.0, -1.38, 0.0)
	event.ObjsSetMotion(2, "ユリス向くin", 2)
	event.ObjsNextMotion(2, "ユリス向くループ")
	event.CmrsSetPos(-40.71, 43.64, -49.96)
	event.CmrsSetRef(-5.77, 32.65, -99.78)
	event.ObjsSetMotion(0, "うなづき", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_42c67f56(4480460)
	if vm.skipping() then
		return skip(105)
	end
	event.ResetPakuAnim()
	event.SndSePlay(var6, 15)
	event.ObjsSetMotion(2, "なんとin", 2)
	event.ObjsNextMotion(2, "なんと（会話）", 2)
	event.ObjsNextMotion(2, "なんとループ", 4)
	event.SetPakuAnim(2, "通常口パク")
	helper_42c67f56(4480470)
	if vm.skipping() then
		return skip(106)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "会話", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_42c67f56(4480480)
	if vm.skipping() then
		return skip(107)
	end
	event.ResetPakuAnim()
	event.FadeOutBgm(30)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(108)
	end
	event.StopBgm(0)
	event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
	event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
	event.ObjsSetMotion(2, "立ち", 4)
	event.ObjsSetRot(1, 0.0, -0.42, 0.0)
	event.CmrsSetPos(-55.29, 35.05, -118.99)
	event.CmrsSetRef(-21.97, 32.65, -81.62)
	event.ObjsSetMotion(3, "会話2")
	event.SetPakuAnim(3, "口パク")
	helper_42c67f56(4480490)
	if vm.skipping() then
		return skip(109)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(3, "口パク")
	helper_42c67f56(4480495)
	if vm.skipping() then
		return skip(110)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(3, "立ち")
	event.ObjsSetMotion(0, "うなづく", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	helper_42c67f56(4480500)
	if vm.skipping() then
		return skip(111)
	end
	helper_42c67f56(4480510)
	if vm.skipping() then
		return skip(112)
	end
	event.ObjsSetMotion(3, "下向く", 6)
	event.ObjsNextMotion(3, "下向くL", 4)
	helper_42c67f56(4480520)
	if vm.skipping() then
		return skip(113)
	end
	helper_c1c32f84(15)
	if vm.skipping() then
		return skip(114)
	end
	event.LoadBgm(5)
	event.CmrsSetPos(-21.1, 62.41, -39.24)
	event.CmrsSetRef(5.13, 26.57, 9.54)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(115)
	end
	event.PlayBgm(0)
	event.ObjsSetMotion(3, "下向く戻り", 6)
	event.ObjsNextMotion(3, "会話2", 4)
	event.SetPakuAnim(3, "口パク")
	helper_42c67f56(4480530)
	if vm.skipping() then
		return skip(116)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(3, "口パク")
	helper_42c67f56(4480535)
	if vm.skipping() then
		return skip(117)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(3, "立ち")
	helper_c1c32f84(15)
	if vm.skipping() then
		return skip(118)
	end
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "前向き～右向き")
	event.ObjsSetRot(1, 0.0, -0.42, 0.0)
	event.ObjsResetDaPosition(1)
	event.CmrsSetPos(-162.52, 46.79, -31.74)
	event.CmrsSetRef(19.74, 41.85, -50.98)
	event.ObjsSetMotion(3, "会話", 6)
	event.ObjsNextMotion(3, "会話2")
	event.SetPakuAnim(3, "口パク")
	helper_42c67f56(4480540)
	if vm.skipping() then
		return skip(119)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(3, "立ち")
	event.ObjsSetMotion(0, "会話", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	helper_42c67f56(4480550)
	if vm.skipping() then
		return skip(120)
	end
	helper_c1c32f84(15)
	if vm.skipping() then
		return skip(121)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(0, 1, "半口")
	event.ObjsSetPos(1, 17.0, 14.67, -96.4)
	event.ObjsSetRot(1, 0.0, -0.42, 0.0)
	event.ObjsSetPos(0, -17.0, 14.67, -96.4)
	event.ObjsSetRot(0, 0.0, 0.06, 0.0)
	event.ObjsResetDaPosition(1)
	event.ObjsResetDaPosition(0)
	event.CmrsSetPos(30.34, 36.89, -45.36)
	event.CmrsSetRef(3.39, 33.28, -93.72)
	helper_42c67f56(4480560)
	if vm.skipping() then
		return skip(122)
	end
	event.ObjsSetMotion(0, "左向く", 6)
	event.ObjsNextMotion(0, "左向くL", 4)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(123)
	end
	event.ObjsSetRot(0, 0.0, 0.42, 0.0)
	event.CmrsSetPos(0.93, 19.93, -42.57)
	event.CmrsSetRef(0.16, 32.65, -3.38)
	event.ObjsSetMotion(3, "会話2")
	event.SetPakuAnim(3, "口パク")
	helper_42c67f56(4480565)
	if vm.skipping() then
		return skip(124)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(3, "立ち")
	helper_c1c32f84(15)
	if vm.skipping() then
		return skip(125)
	end
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsSetMotion(0, "立ち", 4)
	event.CmrsSetPos(-162.52, 46.79, -31.74)
	event.CmrsSetRef(19.74, 41.85, -50.98)
	event.ObjsSetMotion(3, "会話", 6)
	event.ObjsNextMotion(3, "会話2")
	event.SetPakuAnim(3, "口パク")
	helper_42c67f56(4480570)
	if vm.skipping() then
		return skip(126)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(3, "口パク")
	helper_42c67f56(4480575)
	if vm.skipping() then
		return skip(127)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(3, "立ち")
	helper_c1c32f84(15)
	if vm.skipping() then
		return skip(128)
	end
	event.CmrsSetPos(-55.29, 35.05, -118.99)
	event.CmrsSetRef(-21.97, 32.65, -81.62)
	event.ObjsSetMotion(3, "会話2")
	event.SetPakuAnim(3, "口パク")
	helper_42c67f56(4480580)
	if vm.skipping() then
		return skip(129)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(3, "立ち")
	event.SetPakuAnim(3, "口パク")
	helper_42c67f56(4480590)
	if vm.skipping() then
		return skip(130)
	end
	event.ResetPakuAnim()
	helper_c1c32f84(15)
	if vm.skipping() then
		return skip(131)
	end
	event.CmrsSetPos(-23.01, 33.54, -27.56)
	event.CmrsSetRef(5.73, 39.63, 4.67)
	event.ObjsSetMotion(3, "会話2")
	event.SetPakuAnim(3, "口パク")
	helper_42c67f56(4480600)
	if vm.skipping() then
		return skip(132)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(3, "口パク")
	helper_42c67f56(4480605)
	if vm.skipping() then
		return skip(133)
	end
	event.ResetPakuAnim()
	event.SpriteSetDraw(0, 1)
	event.ObjsSetColor(10, 128, 128, 128, 128, 30)
	helper_42c67f56(4480610)
	if vm.skipping() then
		return skip(134)
	end
	helper_42c67f56(4480615)
	if vm.skipping() then
		return skip(135)
	end
	helper_42c67f56(4480620)
	if vm.skipping() then
		return skip(136)
	end
	helper_42c67f56(4480630)
	if vm.skipping() then
		return skip(137)
	end
	helper_42c67f56(4480635)
	if vm.skipping() then
		return skip(138)
	end
	event.SpriteSetDraw(1, 1)
	event.ObjsSetColor(11, 128, 128, 128, 128, 30)
	helper_42c67f56(4480640)
	if vm.skipping() then
		return skip(139)
	end
	helper_42c67f56(4480645)
	if vm.skipping() then
		return skip(140)
	end
	helper_42c67f56(4480650)
	if vm.skipping() then
		return skip(141)
	end
	helper_42c67f56(4480660)
	if vm.skipping() then
		return skip(142)
	end
	helper_42c67f56(4480665)
	if vm.skipping() then
		return skip(143)
	end
	event.SpriteSetDraw(2, 1)
	event.ObjsSetColor(12, 128, 128, 128, 128, 30)
	helper_42c67f56(4480670)
	if vm.skipping() then
		return skip(144)
	end
	helper_42c67f56(4480680)
	if vm.skipping() then
		return skip(145)
	end
	helper_42c67f56(4480690)
	if vm.skipping() then
		return skip(146)
	end
	helper_42c67f56(4480700)
	if vm.skipping() then
		return skip(147)
	end
	helper_42c67f56(4480710)
	if vm.skipping() then
		return skip(148)
	end
	event.SpriteSetDraw(3, 1)
	event.ObjsSetColor(13, 128, 128, 128, 128, 30)
	helper_42c67f56(4480720)
	if vm.skipping() then
		return skip(149)
	end
	helper_42c67f56(4480730)
	if vm.skipping() then
		return skip(150)
	end
	helper_42c67f56(4480735)
	if vm.skipping() then
		return skip(151)
	end
	helper_42c67f56(4480740)
	if vm.skipping() then
		return skip(152)
	end
	helper_42c67f56(4480750)
	if vm.skipping() then
		return skip(153)
	end
	helper_42c67f56(4480760)
	if vm.skipping() then
		return skip(154)
	end
	event.SpriteSetDraw(4, 1)
	event.ObjsSetColor(14, 128, 128, 128, 128, 30)
	helper_42c67f56(4480770)
	if vm.skipping() then
		return skip(155)
	end
	helper_42c67f56(4480775)
	if vm.skipping() then
		return skip(156)
	end
	helper_42c67f56(4480780)
	if vm.skipping() then
		return skip(157)
	end
	helper_42c67f56(4480790)
	if vm.skipping() then
		return skip(158)
	end
	helper_42c67f56(4480795)
	if vm.skipping() then
		return skip(159)
	end
	event.SpriteSetDraw(5, 1)
	event.ObjsSetColor(15, 128, 128, 128, 128, 30)
	helper_42c67f56(4480800)
	if vm.skipping() then
		return skip(160)
	end
	helper_42c67f56(4480805)
	if vm.skipping() then
		return skip(161)
	end
	event.SpriteSetDraw(6, 1)
	event.ObjsSetColor(16, 128, 128, 128, 128, 30)
	helper_42c67f56(4480810)
	if vm.skipping() then
		return skip(162)
	end
	helper_42c67f56(4480815)
	if vm.skipping() then
		return skip(163)
	end
	event.CmrsSetPos(-38.5, 41.66, -29.35)
	event.CmrsSetRef(0.0, 35.62, 0.0)
	event.SpriteSetDraw(0, 0)
	event.SpriteSetDraw(1, 0)
	event.SpriteSetDraw(2, 0)
	event.SpriteSetDraw(3, 0)
	event.SpriteSetDraw(4, 0)
	event.SpriteSetDraw(5, 0)
	event.ObjsSetColor(16, 128, 128, 128, 0, 30)
	event.SetPakuAnim(3, "口パク")
	helper_42c67f56(4480820)
	if vm.skipping() then
		return skip(164)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(3, "下向く", 6)
	event.ObjsNextMotion(3, "下向くL", 4)
	helper_c1c32f84(60)
	if vm.skipping() then
		return skip(165)
	end
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsSetRot(1, 0.0, -1.38, 0.0)
	event.CmrsSetPos(-37.37, 25.85, -54.46)
	event.CmrsSetRef(-10.76, 35.62, -86.97)
	event.SetPakuAnim(0, "通常口パク")
	helper_42c67f56(4480830)
	if vm.skipping() then
		return skip(166)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "会話", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_42c67f56(4480840)
	if vm.skipping() then
		return skip(167)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(2, "ユリス向くin", 2)
	event.ObjsNextMotion(2, "ユリス向くループ")
	event.CharaDaEnable(global0, 0)
	event.SndSePlay(var6, 16)
	event.ObjsSetMotion(0, "アトラさわる", 6)
	event.ObjsNextMotion(0, "アトラさわるL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_42c67f56(4480850)
	if vm.skipping() then
		return skip(168)
	end
	event.ResetPakuAnim()
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "目あき～目とじ")
	event.ObjsSetMotion(1, "首振り", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_42c67f56(4480860)
	if vm.skipping() then
		return skip(169)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(1, "通常口パク")
	helper_42c67f56(4480865)
	if vm.skipping() then
		return skip(170)
	end
	event.ResetPakuAnim()
	helper_c1c32f84(15)
	if vm.skipping() then
		return skip(171)
	end
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.CmrsSetPos(42.2, 46.5, -67.56)
	event.CmrsSetRef(0.69, 36.17, -95.69)
	event.ObjsSetMotion(1, "会話", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_42c67f56(4480870)
	if vm.skipping() then
		return skip(172)
	end
	event.ResetPakuAnim()
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsSetMotion(1, "会話", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_42c67f56(4480880)
	if vm.skipping() then
		return skip(173)
	end
	event.ResetPakuAnim()
	helper_c1c32f84(15)
	if vm.skipping() then
		return skip(174)
	end
	event.CmrsSetPos(-8.37, 35.97, -85.14)
	event.CmrsSetRef(-17.52, 30.64, -95.93)
	helper_42c67f56(4480890)
	if vm.skipping() then
		return skip(175)
	end
	helper_c1c32f84(15)
	if vm.skipping() then
		return skip(176)
	end
	event.CmrsSetPos(-21.1, 62.41, -39.24)
	event.CmrsSetRef(5.13, 26.57, 9.54)
	event.ObjsSetMotion(3, "会話2")
	event.SetPakuAnim(3, "口パク")
	helper_42c67f56(4480900)
	if vm.skipping() then
		return skip(177)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(3, "立ち")
	helper_c1c32f84(15)
	if vm.skipping() then
		return skip(178)
	end
	event.CharaDaEnable(global0, 1)
	event.ObjsSetMotion(0, "立ち", 4)
	event.CmrsSetPos(-162.52, 46.79, -31.74)
	event.CmrsSetRef(19.74, 41.85, -50.98)
	event.ObjsSetMotion(3, "会話2")
	event.SetPakuAnim(3, "口パク")
	helper_42c67f56(4480910)
	if vm.skipping() then
		return skip(179)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(3, "立ち")
	event.ObjsSetMotion(0, "会話", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_42c67f56(4480920)
	if vm.skipping() then
		return skip(180)
	end
	event.ResetPakuAnim()
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(181)
	end
	event.CmrsSetPos(-55.29, 35.05, -118.99)
	event.CmrsSetRef(-21.97, 32.65, -81.62)
	event.SetPakuAnim(3, "口パク")
	helper_42c67f56(4480930)
	if vm.skipping() then
		return skip(182)
	end
	event.ResetPakuAnim()
	helper_42c67f56(4480940)
	if vm.skipping() then
		return skip(183)
	end
	event.ObjsSetMotion(3, "首ふる", 2)
	event.ObjsNextMotion(3, "会話2")
	event.SetPakuAnim(3, "口パク")
	helper_42c67f56(4480950)
	if vm.skipping() then
		return skip(184)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(3, "口パク")
	helper_42c67f56(4480955)
	if vm.skipping() then
		return skip(185)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(3, "口パク")
	helper_42c67f56(4480960)
	if vm.skipping() then
		return skip(186)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(3, "立ち")
	helper_c1c32f84(15)
	if vm.skipping() then
		return skip(187)
	end
	event.CmrsSetPos(-23.01, 33.54, -27.56)
	event.CmrsSetRef(5.73, 39.63, 4.67)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(188)
	end
	event.StopBgm(0)
	event.SndSePlay(var6, 17)
	event.SetMotion(42, "はっとする", 6, -1, 1)
	event.ObjsSetMotion(3, "はっとする", 6)
	helper_c1c32f84(36)
	if vm.skipping() then
		return skip(189)
	end
	event.LoadBgm(37)
	event.PlayBgm(0)
	event.ObjsSetRot(1, 0.0, -0.42, 0.0)
	event.ObjsResetDaPosition(1)
	event.CmrsSetPos(-0.67, 77.75, -189.39)
	event.CmrsSetRef(0.41, 26.8, 10.88)
	event.ObjsSetMotion(3, "会話2")
	event.SetPakuAnim(3, "口パク")
	helper_42c67f56(4480970)
	if vm.skipping() then
		return skip(190)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(3, "立ち")
	event.SndSePlay(var6, 18)
	event.ObjsSetMotion(2, "もう少しin", 6)
	event.ObjsNextMotion(2, "もう少し（会話）", 2)
	event.ObjsNextMotion(2, "もう少しループ")
	helper_42c67f56(4480980)
	if vm.skipping() then
		return skip(191)
	end
	event.ObjsNextMotion(2, "もう少し（会話）", 2)
	event.ObjsNextMotion(2, "もう少しループ")
	helper_42c67f56(4480985)
	if vm.skipping() then
		return skip(192)
	end
	event.ObjsSetMotion(3, "会話", 6)
	event.ObjsNextMotion(3, "会話2")
	event.SetPakuAnim(3, "口パク")
	helper_42c67f56(4480990)
	if vm.skipping() then
		return skip(193)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(3, "立ち")
	event.ObjsNextMotion(2, "もう少し（会話）", 2)
	event.ObjsSetMotion(2, "もう少しループ")
	helper_42c67f56(4481000)
	if vm.skipping() then
		return skip(194)
	end
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(195)
	end
	event.CmrsSetPos(-38.5, 41.66, -29.35)
	event.CmrsSetRef(0.0, 35.62, 0.0)
	event.ObjsSetMotion(3, "会話2")
	event.SetPakuAnim(3, "口パク")
	helper_42c67f56(4481010)
	if vm.skipping() then
		return skip(196)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(3, "会話", 6)
	event.ObjsNextMotion(3, "会話2")
	event.SetPakuAnim(3, "口パク")
	helper_42c67f56(4481015)
	if vm.skipping() then
		return skip(197)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(3, "胸に手をあてる", 6)
	event.ObjsNextMotion(3, "胸に手をあてるL", 4)
	event.SetPakuAnim(3, "口パク")
	helper_42c67f56(4481020)
	if vm.skipping() then
		return skip(198)
	end
	event.ResetPakuAnim()
	helper_c1c32f84(15)
	if vm.skipping() then
		return skip(199)
	end
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsSetMotion(2, "立ち", 4)
	event.CmrsSetPos(-37.37, 25.85, -54.46)
	event.CmrsSetRef(-10.76, 35.62, -86.97)
	event.ObjsSetMotion(1, "会話", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_42c67f56(4481030)
	if vm.skipping() then
		return skip(200)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(2, "ユリス向くin", 2)
	event.ObjsNextMotion(2, "ユリス向くループ")
	event.ObjsSetMotion(0, "会話", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_42c67f56(4481040)
	if vm.skipping() then
		return skip(201)
	end
	event.ResetPakuAnim()
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "前向き～右向き")
	event.ObjsSetMotion(0, "会話", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_42c67f56(4481045)
	if vm.skipping() then
		return skip(202)
	end
	event.ResetPakuAnim()
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(203)
	end
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetMotion(2, "立ち", 4)
	event.ObjsSetMotion(1, "立ち", 4)
	event.CmrsSetPos(-162.52, 46.79, -31.74)
	event.CmrsSetRef(19.74, 41.85, -50.98)
	event.ObjsSetMotion(3, "会話2")
	event.SetPakuAnim(3, "口パク")
	helper_42c67f56(4481050)
	if vm.skipping() then
		return skip(204)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(3, "立ち")
	helper_42c67f56(4481055)
	if vm.skipping() then
		return skip(205)
	end
	event.ObjsSetMotion(0, "うなづく", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.ObjsSetMotion(1, "うなづく", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SndSePlay(var6, 19)
	event.SndSePlay(var6, 20)
	helper_42c67f56(4481060)
	if vm.skipping() then
		return skip(206)
	end
	helper_c1c32f84(15)
	if vm.skipping() then
		return skip(207)
	end
	event.CmrsSetPos(0.14, 59.84, -159.42)
	event.CmrsSetRef(-0.03, 38.48, -81.63)
	event.SetMotion(42, "消える", 6, -1, 1)
	event.SetCharaShow(39, 0, 1, 0.05)
	event.SndSePlay(var6, 21)
	helper_c1c32f84(60)
	if vm.skipping() then
		return skip(208)
	end
	event.ObjsSetMotion(2, "歩き")
	event.ObjsMove(2, -0.11, 14.67, -49.09, 60, 1)
	helper_2386f745(2)
	if vm.skipping() then
		return skip(209)
	end
	event.SndSePlay(var6, 22)
	event.ObjsSetMotion(2, "振り向く（逆）")
	event.ObjsRotation(2, 0.0, 3.12, 0.0, 30)
	helper_2386f745(2)
	if vm.skipping() then
		return skip(210)
	end
	event.ObjsSetMotion(2, "立ち")
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(211)
	end
	event.ObjsSetMotion(2, "会話", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.SetPakuAnim(2, "通常口パク")
	helper_42c67f56(4481070)
	if vm.skipping() then
		return skip(212)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(2, "会話", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.SetPakuAnim(2, "通常口パク")
	helper_42c67f56(4481075)
	if vm.skipping() then
		return skip(213)
	end
	event.ResetPakuAnim()
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(214)
	end
	event.CmrsSetPos(-39.91, 25.25, -77.93)
	event.CmrsSetRef(-0.1, 29.77, -48.62)
	event.ObjsSetMotion(2, "会話", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.SetPakuAnim(2, "通常口パク")
	helper_42c67f56(4481080)
	if vm.skipping() then
		return skip(215)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(2, "会話", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.SetPakuAnim(2, "通常口パク")
	helper_42c67f56(4481090)
	if vm.skipping() then
		return skip(216)
	end
	event.ResetPakuAnim()
	helper_c1c32f84(15)
	if vm.skipping() then
		return skip(217)
	end
	event.ObjsSetRot(1, 0.0, -1.38, 0.0)
	event.ObjsResetDaPosition(1)
	event.CmrsSetPos(1.03, 69.38, -3.58)
	event.CmrsSetRef(-0.03, 27.73, -81.63)
	event.ObjsSetMotion(0, "会話", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_42c67f56(4481100)
	if vm.skipping() then
		return skip(218)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "会話", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_42c67f56(4481110)
	if vm.skipping() then
		return skip(219)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "会話", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_42c67f56(4481115)
	if vm.skipping() then
		return skip(220)
	end
	event.ResetPakuAnim()
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(221)
	end
	event.ObjsSetRot(0, 0.0, 0.06, 0.0)
	event.ObjsResetDaPosition(0)
	event.CmrsSetPos(40.04, 39.75, -68.21)
	event.CmrsSetRef(-6.7, 35.75, -106.34)
	event.SndSePlay(var6, 23)
	event.ObjsSetMotion(0, "がっつ", 6)
	event.ObjsNextMotion(0, "がっつL", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_42c67f56(4481120)
	if vm.skipping() then
		return skip(222)
	end
	event.ResetPakuAnim()
	event.SndSePlay(var6, 24)
	event.ObjsSetMotion(1, "うなづく", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(223)
	end
	return part2()
end

--- Helper function.
local function helper_29718(arg0: f32)
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
	helper_2386f745(0)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsSetMotion(0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_29c1c(arg0: f32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_c1c32f84(30)
		end
	end
	helper_29718(arg0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMotion(0, "立ち")
	var2 = event.GetSndId(2) or var2
	if arg1 ~= 0 then
		event.SndSePlay(var2, 92)
	else
		event.SndSePlay(var2, 94)
	end
	event.SetFadeOut(30)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_10a7c()
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
			helper_daa89e49(0, -1, var1, player_chara, 0)
		end
		if at <= 2 then
			var3 = 1
			helper_87aa4a59(var1, -1, 0, 0)
		end
		if at <= 3 then
			helper_daa89e49(0, -1, var1, player_chara, 0)
		end
		if at <= 4 then
			helper_99a9b842(player_chara_2, var22)
		end
		if at <= 5 then
			helper_daa89e49(0, -1, var1, player_chara_2, 0)
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
	event.MesMake_2(0, "Salve.\nTempo stupendo, vero?")
	var3 = 0
	if var2 == 300 then
		flag = event.GetFlag(640) or flag
		if flag == 0 then
			flag_2 = event.GetFlag(456) or flag_2
			if flag_2 == 0 then
				event.MesMake_2(
					0,
					"Eh? Chi siete...?\nIl Laboratorio di Scienza Lunatica\n[UNI00e8] il miglior centro di ricerca<page>del mondo. Non [UNI00e8] ancora un\ngranch[UNI00e9], ma dovremmo riuscire\na terminare i nostri studi."
				)
			else
				event.MesMake_2(
					0,
					"Le parole non possono descrivere\nla maestosit[UNI00e0] del Lab-Lunatica.\nDovete vederlo con i vostri occhi."
				)
			end
		else
			event.MesMake_2(
				0,
				"Se la questione Grifone non viene\nrisolta, la storia non torner[UNI00e0]\nmai com'era prima.<page>La sola esistenza di Grifone\naltera il corso della storia."
			)
		end
	end
	if var2 == 301 then
		flag_3 = event.GetFlag(420) or flag_3
		if flag_3 == 0 then
			flag_4 = event.GetFlag(408) or flag_4
			if flag_4 == 0 then
				event.MesMake_2(0, "Haahn, shooo, haahn, shooo.")
				var3 = 2
			else
				argc = event.GetInventionId(309) or argc
				if argc < 0 then
					event.MesMake_2(
						0,
						"Ecco delle dritte per inventare un\nacquario: Una Scatola di Legno,\nuna Finestra e una Fontana. Puoi\ntrovarli in citt[UNI00e0], capito?"
					)
				else
					var9 = event.GetSavedataEtc(2) or var9
					if var9 == 0 then
						event.MesMake_2(
							0,
							"Prima, dai un \"Verme elettrico\"\na un pesce dell'acquario\nper elettrificarlo.<page>Poi, dai il pesce allo Shigura.\nTutto chiaro, 'sta volta?"
						)
					else
						event.MesMake_2(
							0,
							"Ooh, hai il pesce, vero?\nDallo da mangiare allo Shigura!\nNon dovrebbe essere difficile, no?"
						)
					end
				end
			end
		else
			event.MesMake_2(
				0,
				"Bene! Sembra ce l'abbiate fatta!\nA quanto pare, la mia invenzione\n[UNI00e8] stata proprio utile, eh?"
			)
		end
	end
	if var2 == 302 then
		event.MesMake_2(0, "Che sia Osmond o il capo del\nlaboratorio, ce n'[UNI00e8] di matti qui!")
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
							"Badate alla Radioconchiglia.\n[UNI00c8] tra le invenzioni pi[UNI00f9]\nimportanti del Lab-Lunatica."
						)
					else
						event.MesMake_2(
							0,
							"Presto, muovetevi! Le truppe\ndi Grifone stanno raggiungendo\nElena: non resisteranno a lungo..."
						)
					end
				else
					event.MesMake_2(0, "Mi chiedo che uomo sia\nquesto Grifone...")
				end
			else
				event.MesMake_2(
					0,
					"Cercate le gemme? Sono cristalli\ndi saggezza, forgiati dagli antichi.<page>Secondo l'analisi del computer del\nLab-Lunatica,si trovano nascoste\nin quattro luoghi:"
				)
				helper_8349b4fe(player_chara, var1, 0)
				if vm.skipping() then
					return skip(1)
				end
				helper_daa89e49(0, -1, var1, player_chara, 0)
				if vm.skipping() then
					return skip(2)
				end
				var3 = 1
				event.MesMake_2(
					0,
					"il Bosco Farfalla Arcobaleno, il\nCanyon Stellare, la Caverna \nRuggente e il Monte Gundor.<page>Un simbolo a forma di stella\ndovrebbe trovarsi ad ogni entrata,\nquindi fate attenzione."
				)
			end
		else
			event.MesMake_2(
				0,
				"Bene, [UNI00e8] ora di sistemare Grifone\nper sempre! Il destino del mondo [UNI00e8]\nnelle vostre mani. Buona fortuna!"
			)
		end
	end
	if var2 == 304 then
		event.MesMake_2(
			0,
			"In questo laboratorio, anche un\nragazzino, con le giuste qualit[UNI00e0],\npu[UNI00f2] diventare un pezzo grosso."
		)
	end
	if var2 == 305 then
		event.MesMake_2(
			0,
			"Le Pietre Luna, portate dagli\nShigura, ci liberano la mente per\nmeglio concentrarci sulla ricerca.<page>Ma non saprei dirti cosa siano\nesattamente queste Pietre Luna..."
		)
	end
	if var2 == 306 then
		event.MesMake_2(
			0,
			"Un laboratorio sull'oceano, niente\nmale, eh? Sapete quanto ho dovuto\nfaticare per avere un posto qui?"
		)
	end
	if var2 == 307 then
		event.MesMake_2(
			0,
			"Che ne pensate del progetto del\nLab-Lunatica? Chiss[UNI00e0] chi ha ideato\nil parco dei divertimenti..."
		)
	end
	if var2 == 308 then
		event.MesMake_2(
			0,
			"Un giorno dimostrer[UNI00f2] a tutti\nquanto sono in gamba! Sapete,\nqui si tratta solo di abilit[UNI00e0]."
		)
	end
	if var2 == 309 then
		event.MesMake_2(
			0,
			'Sapete, io rispetto molto il capo.\n[UNI00c8] da ammirare uno che scrive\nun best seller di 40 volumi,<page>"La Bibbia del Super\nScienziato,", a quell\'et[UNI00e0] poi!'
		)
	end
	if var2 == 310 then
		event.MesMake_2(
			0,
			"Io sono ancora un pivellino qui.\nSto imparando molto e un giorno\ndiventer[UNI00f2] un grande ricercatore."
		)
	end
	if var2 == 311 then
		event.MesMake_2(
			0,
			"La vista del mare da questo\nlaboratorio [UNI00e8] incredibile.<page>Laggi[UNI00f9] all'orizzonte,\nl'oscurit[UNI00e0] del mare e del cielo\nsi fondono in un tutt'uno."
		)
	end
	if var2 == 312 then
		event.MesMake_2(
			0,
			"Questo [UNI00e8] il Laboratorio Numero 2.<page>Nel Lab-Lunatica, ogni\nsingolo laboratorio ha\nla sua area di ricerca."
		)
	end
	if var2 == 313 then
		event.MesMake_2(
			0,
			"Al Lab-Lunatica, viene simulato\nun ambiente notturno che amplifica\nil potere delle Pietre Luna."
		)
	end
	if var2 == 314 then
		event.MesMake_2(
			0,
			"Quando iniziai a lavorare qui, non\nriuscivo neanch'io a distinguere i\nlaboratori. Questo pu[UNI00f2] aiutarvi:<page>il laboratorio 1 [UNI00e8] rosso, il 2 [UNI00e8]\nblu, il 3 [UNI00e8] viola e il 4 [UNI00e8] verde.\nUn colore per ogni laboratorio!"
		)
	end
	if var2 == 315 then
		event.MesMake_2(0, "L'emblema sul Laboratorio Centrale\nha la forma della luna.")
	end
	if var2 == 316 then
		event.MesMake_2(
			0,
			"Ho saputo che il Laboratorio [UNI00e8]\nstato terminato grazie alle Pietre\nLuna portate dal drago Shingala.<page>A quanto pare, alcuni draghi\nmarini sanno essere in gamba, eh?"
		)
	end
	if var2 == 317 then
		event.MesMake_2(
			0,
			"Non dirglielo, ma ne abbiamo fin<page>sopra i capelli delle cosiddette\nbattute di Osmond.\nSono cos[UNI00ec] irritanti!"
		)
	end
	if var2 == 318 then
		event.MesMake_2(
			0,
			"Ebbene s[UNI00ec]: anch'io ho contribuito\nalla ricerca sul Verme elettrico.\nOra seguo un altro progetto.<page>Ehi, non posso rivelare quale!\nTop secret! Mica posso andare a\nspifferarlo ai quattro venti!"
		)
	end
	if var2 == 319 then
		event.MesMake_2(
			0,
			"Cosa? Anche voi ragazzi volete\ndiventare dei ricercatori?<page>Non penserete mica che sia una\npasseggiata entrare qui?!\nLa competizione [UNI00e8] spietata."
		)
	end
	if var2 == 320 then
		event.MesMake_2(
			0,
			"Alcuni ricercatori criticano i\nprogetti qui al Lab-Lunatica.\nIn effetti non sono un granch[UNI00e9]...<page>Ad ogni modo, [UNI00e8] solo\nuna piccola minoranza."
		)
	end
	if var2 == 321 then
		event.MesMake_2(
			0,
			"Siamo nel mezzo di una riunione\nsu ricerche di massima segretezza.<page>Vi spiacerebbe lasciarci\nsoli un momento?"
		)
	end
	if var2 == 322 then
		event.MesMake_2(
			0,
			"Mi spiace molto, ma siamo nel\nmezzo di una riunione su\nricerche di massima segretezza.<page>Non possiamo andare avanti\ncon voi qui, quindi..."
		)
	end
	if var2 == 323 then
		event.MesMake_2(
			0,
			"Il Dottor Nobb [UNI00e8] un vero genio,\ncerto, ma [UNI00e8] anche un\ngran lavoratore.<page>Io impallidisco a confronto...\nUn vero albino direi..."
		)
	end
	if var2 == 324 then
		event.MesMake_2(
			0,
			"Sei tu? Ho sentito dire che hai\nlitigato con il Dottor Osmond.<page>Ehi! Non sto criticando, anzi! Le\nscoperte avvengono quando si mette\nin discussione qualcosa."
		)
	end
	if var2 == 325 then
		event.MesMake_2(
			0,
			"Dite di non riuscire ad abituarvi\nalla luce intensa?<page>Ritengo che per voi\nvisitatori dal passato\nci voglia del tempo per adattarsi."
		)
	end
	if var2 == 326 then
		event.MesMake_2(
			0,
			"Beh, sto riprendendo\nfiato un attimo.<page>Bisogna far riposare il cervello\ndi quando in quando, altrimenti\nsi d[UNI00e0] fuori di matto!"
		)
	end
	if var2 == 327 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no ~= 1 then
			event.MesMake_2(
				0,
				"So che sei bravino come inventore.\nChe ne dici? Ti andrebbe di venire\na lavorare con noi da grande?<page>Per allora, il Lab-Lunatica sar[UNI00e0]\nstato appena terminato. La tua\ncollaborazione sar[UNI00e0] apprezzata."
			)
		else
			event.MesMake_2(
				0,
				"Non credi che gli inventori\nsiano veramente affascinanti?<page>Beh, vedi di non innamorarti di\nme, intesi? La ricerca [UNI00e8] la mia\nvita. Non funzionerebbe mai."
			)
		end
	end
	if var2 == 328 then
		event.MesMake_2(
			0,
			"Ho avuto un'idea rivoluzionaria:\nun sistema che permette ai mostri\ndi vivere al fianco degli Umani.<page>Realizzer[UNI00f2] una macchina che\ncomprende il linguaggio umano."
		)
	end
	if var2 == 329 then
		event.MesMake_2(
			0,
			"Le Pietre Luna sono la spina\ndorsale del Lab-Lunatica.<page>Senza, tutto il nostro\nsistema si paralizzerebbe."
		)
	end
	if var3 == 0 then
		helper_87aa4a59(var1, -1, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
	end
	if var3 == 1 then
		helper_daa89e49(0, -1, var1, player_chara, 0)
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
		helper_99a9b842(player_chara_2, var22)
		if vm.skipping() then
			return skip(5)
		end
		event.SetCharaRot(player_chara_2, 0.0, var22, 0.0)
		event.SetMotion(player_chara_2, "立ち")
		helper_daa89e49(0, -1, var1, player_chara_2, 0)
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
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local var5: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_16a78()
				if not vm.skipping() then
					return landing1()
				end
			end
			return
		end
	end
	function part2()
		flag_4 = event.GetFlag(540) or flag_4
		flag_5 = event.GetFlag(600) or flag_5
		if flag_4 == 1 and flag_5 == 0 then
			event.BgmLoadCancel()
			event.MapJump(-1, "s53", 500)
			if vm.wait() then
				return skip(4)
			end
			return
		end
		var5 = event.GetCnt(2) or var5
		if var5 == 0 then
			helper_9dafbc83(0.0, vm.f32(310.2), vm.f32(938.3), vm.f32(3.14))
		end
		if var5 == 1 then
			helper_9dafbc83(-685.0, vm.f32(226.9), 665.0, vm.f32(2.355))
		end
		if var5 == 2 then
			helper_9dafbc83(-685.0, vm.f32(226.9), -665.0, vm.f32(0.785))
		end
		if var5 == 3 then
			helper_9dafbc83(685.0, vm.f32(226.9), -665.0, vm.f32(-0.785))
		end
		if var5 == 4 then
			helper_9dafbc83(685.0, vm.f32(226.9), 665.0, vm.f32(-2.355))
		end
		event.ResetCamera(1, 0.0, 10)
		event.SetFadeIn(30)
	end
	function landing1()
		event.MapJump(-1, "s09", 500)
		if vm.wait() then
			return skip(3)
		end
	end
	helper_ec30b150()
	flag = event.GetFlag(464) or flag
	if flag == 0 then
		helper_26f68()
		if vm.skipping() then
			return skip(1)
		end
	end
	flag_2 = event.GetFlag(444) or flag_2
	flag_3 = event.GetFlag(448) or flag_3
	if flag_2 == 1 and flag_3 == 0 then
		event.SetFlag(448, 1)
		helper_16a78()
		if vm.skipping() then
			return skip(2)
		end
		event.MapJump(-1, "s09", 500)
		if vm.wait() then
			return skip(3)
		end
		return
	end
	return part2()
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_16a78()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 400.
script[400] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_29c1c(0.0, 1)
	if vm.skipping() then
		return skip(1)
	end
	event.SetCnt(2, 0)
	event.MapJump(-1, "f03")
	if vm.wait() then
		return skip(2)
	end
end

--- Program 401.
script[401] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_29c1c(vm.f32(-0.7853982), 0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetCnt(2, 1)
	event.MapJump(-1, "f03")
	if vm.wait() then
		return skip(2)
	end
end

--- Program 402.
script[402] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_29c1c(vm.f32(-2.3561945), 0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetCnt(2, 2)
	event.MapJump(-1, "f03")
	if vm.wait() then
		return skip(2)
	end
end

--- Program 403.
script[403] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_29c1c(vm.f32(2.3561945), 0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetCnt(2, 3)
	event.MapJump(-1, "f03")
	if vm.wait() then
		return skip(2)
	end
end

--- Program 404.
script[404] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_29c1c(vm.f32(0.7853982), 0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetCnt(2, 4)
	event.MapJump(-1, "f03")
	if vm.wait() then
		return skip(2)
	end
end

--- Program 1000.
script[1000] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_10a7c()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 14480.
script[14480] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_16a78()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s09", 500)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 14640.
script[14640] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_26f68()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 16000.
script[16000] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.MapJump(-1, "s53", 500)
	if vm.wait() then
		return skip(1)
	end
end

return script
