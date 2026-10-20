--!strict
-- map/s/s54/s54.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_05fbffe0 = require("@lib/event/helper_05fbffe0")
local helper_076280e8 = require("@lib/event/helper_076280e8")
local helper_1d96573f = require("@lib/event/helper_1d96573f")
local helper_34727ca1 = require("@lib/event/helper_34727ca1")
local helper_4575bf67 = require("@lib/event/helper_4575bf67")
local helper_582dcd42 = require("@lib/event/helper_582dcd42")
local helper_650bfa16 = require("@lib/event/helper_650bfa16")
local helper_79e692b8 = require("@lib/event/helper_79e692b8")
local helper_868b9caa = require("@lib/event/helper_868b9caa")
local helper_8a56995e = require("@lib/event/helper_8a56995e")
local helper_ac1aeb7a = require("@lib/event/helper_ac1aeb7a")
local helper_b7c85616 = require("@lib/event/helper_b7c85616")
local helper_ff0edc1d = require("@lib/event/helper_ff0edc1d")

--- Helper function.
local function helper_ff38()
	local rot_x: f32 = 0
	local rot_y: f32 = 0
	local rot_z: f32 = 0
	local rot_x_2: f32 = 0
	local var4: f32 = 0
	local rot_z_2: f32 = 0
	local rot_x_3: f32 = 0
	local var7: f32 = 0
	local rot_z_3: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		rot_y = vm.f32(rot_y + 100.0)
		var4 = vm.f32(var4 - vm.f32(1.4))
		var7 = vm.f32(var7 + vm.f32(1.4))
	end
	if vm.skipping() then
		return skip(1)
	end
	event.EohSyncObj(29, "door34", "d07d05_3-m0")
	do
		local out1, out2, out3 = event.EohGetRot(29)
		rot_x = out1 or rot_x
		rot_y = out2 or rot_y
		rot_z = out3 or rot_z
	end
	rot_y = vm.f32(rot_y + 100.0)
	event.EohSyncObj(30, "door34", "d07d05_1-m0")
	do
		local out1, out2, out3 = event.EohGetRot(30)
		rot_x_2 = out1 or rot_x_2
		var4 = out2 or var4
		rot_z_2 = out3 or rot_z_2
	end
	event.EohSyncObj(31, "door34", "d07d05_1-m1")
	do
		local out1, out2, out3 = event.EohGetRot(31)
		rot_x_3 = out1 or rot_x_3
		var7 = out2 or var7
		rot_z_3 = out3 or rot_z_3
	end
	var4 = vm.f32(var4 - vm.f32(1.4))
	var4 = event.AngleLimit(var4) or var4
	var7 = vm.f32(var7 + vm.f32(1.4))
	var7 = event.AngleLimit(var7) or var7
	event.EohSetPos(29, rot_x, rot_y, rot_z)
	event.EohSetRot(30, rot_x_2, var4, rot_z_2)
	event.EohSetRot(31, rot_x_3, var7, rot_z_3)
	event.EohSyncObj(29, "door34", "d07da05a-a")
	event.EohSetShow(29, 0)
	event.EohSyncObj(29, "door34", "d07dv05a-c")
	event.EohSetShow(29, 0)
	event.EohSyncObj(29, "door34", "d07da05b-a")
	event.EohSetShow(29, 1)
	event.EohSyncObj(29, "door34", "d07dv05b-c")
	event.EohSetShow(29, 1)
end

--- Program 99.
local function program_99()
	local flag: s32 = 0
	event.StopBgm(0)
	event.LoadSound(8684)
	flag = event.GetFlag(808) or flag
	if flag == 1 then
		helper_ff38()
	end
end

--- Helper function.
local function helper_1770(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.SetCharaPos(0, arg0, arg1, arg2)
	event.SetCharaRot(0, 0.0, arg3, 0.0)
	event.SetMotion(0, "立ち")
end

--- Helper function.
local function helper_10690()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local block: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 24 then
			if at <= 1 then
				helper_ff0edc1d(70)
			end
			if at <= 2 then
				helper_1d96573f(8080010)
			end
			if at <= 3 then
				helper_1d96573f(8080020)
			end
			if at <= 4 then
				helper_1d96573f(8080030)
			end
			if at <= 5 then
				helper_650bfa16(0)
			end
			if at <= 6 then
				helper_650bfa16(1)
			end
			if at <= 7 then
				helper_076280e8()
			end
			if at <= 8 then
				helper_650bfa16(2)
			end
			if at <= 9 then
				helper_1d96573f(8080040)
			end
			if at <= 10 then
				helper_1d96573f(8080045)
			end
			if at <= 11 then
				helper_1d96573f(8080050)
			end
			if at <= 12 then
				helper_1d96573f(8080060)
			end
			if at <= 13 then
				helper_1d96573f(8080070)
			end
			if at <= 14 then
				helper_1d96573f(8080075)
			end
			if at <= 15 then
				helper_650bfa16(2)
			end
			if at <= 16 then
				helper_1d96573f(8080080)
			end
			if at <= 17 then
				helper_1d96573f(8080090)
			end
			if at <= 18 then
				helper_8a56995e(1)
			end
			if at <= 19 then
				helper_05fbffe0(0, 180)
			end
			if at <= 20 then
				helper_ff0edc1d(10)
			end
			if at <= 21 then
				helper_ff0edc1d(50)
			end
			if at <= 22 then
				helper_ff0edc1d(21)
			end
			if at <= 23 then
				helper_ff0edc1d(3)
			end
			if vm.skip_end() then
				return skip(25)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var1, 0)
		event.SndSeStop(var1, 1)
		event.SndSeStop(var1, 2)
		event.SndSeStop(var1, 3)
		event.SpriteSetDraw(0, 0)
		event.SetMotionBlur(0)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.DelImg(0)
		event.LoadMes(0, -1)
		event.PlayBgm(0)
		event.SetStatusbarShow(1, 1.0)
		event.SetCharaShow(1, 1)
		event.SetCharaShow(2, 1)
		event.Finish()
	end
	event.SetFlag(808, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.StopBgm(0)
	helper_ff0edc1d(6)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(107)
	event.LoadSound(8803)
	var1 = event.SndLoadSound(8803) or var1
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e800/e808/")
	event.LoadMes(0, 5, "e808.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e808_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e808_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e808_m_polcurse.gltf", "info", 10)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e808_mp_jet.gltf", "info", 11)
	event.CharaActive(11)
	event.SetReference(10, "jet_l", 11)
	event.CopyChara(5, 11, 12)
	event.CharaActive(12)
	event.SetReference(10, "jet_r", 12)
	block = event.LoadImg_4(5, "e808telop01.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e808telop01", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 128)
	event.SpriteSetPutsize(0, 512, 128)
	event.SpriteSetPos(0, 256, 312)
	event.SpriteSetAlphab(0, 0)
	event.SpriteSetDraw(0, 0)
	event.EohSyncSprite(3, 0)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 8)
		event.LoadEquip(5, 0, 4, "info", 8)
		event.LoadEquip(5, 0, 3, "info", 8)
		event.LoadEquip(5, 0, 2, "info", 8, 9)
		event.LoadMotion(5, "event/e800/e808/e808_mints.gltf", "info", 8)
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
		event.LoadMotion(5, "event/e800/e808/e808_monica.gltf", "info", 8)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 8)
		event.EohSyncChara(1, 8)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(8)
	event.CharaActive(9)
	event.SetCharaShow(1, 0)
	event.SetCharaShow(2, 0)
	event.EohSetPos(0, -10.0, 0.0, 0.0)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 16)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "無表情")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetPos(1, 10.0, 0.0, 0.0)
	event.EohSetRot(1, 0.0, 0.0, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetFootSoundId(1, 16)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "無表情")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.EohSetPos(2, 0.0, 1200.0, 1200.0)
	event.EohSetRot(2, 0.0, 3.14, 0.0)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "デフォルト顔")
	event.EohSetTexAnim(2, 1, "通常目パチ")
	event.SetStatus(1, 10, 8)
	event.InitDramaScene()
	event.ObjsMove(0, -10.0, 0.0, 100.0, 100)
	event.ObjsSetMotion(0, "歩き", 4)
	event.ObjsMotionDelay(0, 100)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsMove(1, 10.0, 0.0, 100.0, 100)
	event.ObjsSetMotion(1, "歩き", 4)
	event.ObjsMotionDelay(1, 100)
	event.ObjsSetMotion(1, "立ち")
	event.CmrsInit()
	event.CmrsSetPos(-144.53, 162.53, 269.71)
	event.CmrsSetRef(9.57, 6.12, 32.98)
	event.SetFadeIn(30)
	helper_ff0edc1d(70)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(0.0, 20.0, 60.0)
	event.CmrsSetRef(0.0, 20.0, 100.0)
	event.SetPakuAnim(2, "通常口パク")
	helper_1d96573f(8080010)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(0, "上向く", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.ObjsMotionDelay(1, 10)
	event.ObjsSetMotion(1, "上向く", 6)
	event.ObjsNextMotion(1, "上向くL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_1d96573f(8080020)
	if vm.skipping() then
		return skip(4)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_1d96573f(8080030)
	if vm.skipping() then
		return skip(5)
	end
	helper_650bfa16(0)
	if vm.skipping() then
		return skip(6)
	end
	helper_650bfa16(1)
	if vm.skipping() then
		return skip(7)
	end
	event.SndSePlay(var1, 0)
	event.PlayBgm(0)
	event.CmrsMove2(0.0, 55.07, 16.58, 0.0, 132.31, 102.11, 60, 0, 0.4)
	event.ObjsSetRot(2, 0.8, 3.14, 0.0)
	event.ObjsMove2(2, 0.0, 70.0, 80.0, 100, 2, 0.1)
	event.ObjsSetMotion(2, "飛びループ", 4)
	event.ObjsMotionDelay(2, 86)
	event.ObjsSetMotion(2, "体返す", 2)
	event.ObjsNextMotion(2, "体返すＬ", 4)
	helper_076280e8()
	if vm.skipping() then
		return skip(8)
	end
	helper_650bfa16(2)
	if vm.skipping() then
		return skip(9)
	end
	event.SndSeStop(var1, 0)
	event.ObjsSetRot(0, 0.0, 0.12, 0.0)
	event.ObjsSetRot(1, 0.0, -0.12, 0.0)
	event.SetPakuMotion(2, "体返す会話", 4, "体返すＬ", 0)
	event.SetPakuAnim(2, "通常口パク")
	helper_1d96573f(8080040)
	if vm.skipping() then
		return skip(10)
	end
	event.SetPakuMotion(2, "体返す会話", 0, "体返すＬ", 0)
	event.SetPakuAnim(2, "通常口パク")
	helper_1d96573f(8080045)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(-2.41, 61.81, 165.8)
	event.CmrsSetRef(0.11, 17.53, 101.88)
	event.SetPakuAnim(0, "通常口パク")
	helper_1d96573f(8080050)
	if vm.skipping() then
		return skip(12)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_1d96573f(8080060)
	if vm.skipping() then
		return skip(13)
	end
	event.CmrsSetPos(0.0, 104.52, 45.06)
	event.CmrsSetRef(0.0, 124.09, 102.11)
	event.ObjsSetRot(2, 0.0, 3.14, 0.0)
	event.ObjsSetMotion(2, "浮遊立ち会話", 4)
	event.SetPakuMotion(2, "浮遊立ち会話", 4, "浮遊立ち", 0)
	event.SetPakuAnim(2, "わらい口パク")
	helper_1d96573f(8080070)
	if vm.skipping() then
		return skip(14)
	end
	event.SetPakuMotion(2, "浮遊立ち会話", 0, "浮遊立ち", 0)
	event.SetPakuAnim(2, "わらい口パク")
	helper_1d96573f(8080075)
	if vm.skipping() then
		return skip(15)
	end
	helper_650bfa16(2)
	if vm.skipping() then
		return skip(16)
	end
	event.SndSePlay(var1, 1)
	event.ObjsSetMotion(2, "オーホホホ", 2)
	event.ObjsNextMotion(2, "オーホホホＬ", 4)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "通常目～高笑い")
	event.SetPakuAnim(2, "わらい口パク")
	helper_1d96573f(8080080)
	if vm.skipping() then
		return skip(17)
	end
	event.CmrsSetPos(-29.09, 25.94, 131.55)
	event.CmrsSetRef(5.81, 19.33, 91.49)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "いぶかしげ顔")
	event.EohSetTexAnim(0, 1, "いぶかしげ目パチ")
	event.SetPakuAnim(0, "通常口パク")
	helper_1d96573f(8080090)
	if vm.skipping() then
		return skip(18)
	end
	event.CmrsSetPos(0.5, 125.0, 60.0)
	event.CmrsSetRef(0.5, 125.0, 92.0)
	event.CmrsMove2(0.5, 115.0, 20.0, 0.5, 115.0, 92.0, 40, 2, 0.2)
	event.SndSePlay(var1, 2)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "おこり顔")
	event.EohSetTexAnim(2, 1, "おこり目パチ")
	event.ObjsSetMotion(2, "ポーズ", 6)
	event.ObjsNextMotion(2, "ポーズＬ", 4)
	event.SpriteSetDraw(0, 1)
	event.ObjsSetColor(3, 128, 128, 128, 128, 30)
	event.SetPakuAnim(2, "通常口パク")
	event.StreamOpen3(1, 8080100)
	helper_8a56995e(1)
	if vm.skipping() then
		return skip(19)
	end
	event.StreamPlay(1)
	helper_05fbffe0(0, 180)
	if vm.skipping() then
		return skip(20)
	end
	event.StreamClose(1)
	event.SndSePlay(var1, 3)
	event.ObjsSetColor(3, 128, 128, 128, 0, 10)
	event.ObjsSetMotion(2, "ゴゴゴゴ", 6)
	event.ObjsNextMotion(2, "ゴゴゴゴＬ", 6)
	event.ObjsNextMotion(2, "カメラに向かう", 6)
	event.ObjsNextMotion(2, "飛びループ", 4)
	event.ObjsRotDelay(2, 30)
	event.ObjsRotation(2, 0.2, 3.14, 0.0, 40)
	event.ObjsPosDelay(2, 64)
	event.ObjsMove(2, 0.0, 66.0, 0.0, 20)
	event.CmrsMove2(0.0, 90.93, -24.95, 0.0, 108.12, 88.77, 40, 0, 0.4)
	helper_ff0edc1d(10)
	if vm.skipping() then
		return skip(21)
	end
	event.SpriteSetDraw(0, 0)
	helper_ff0edc1d(50)
	if vm.skipping() then
		return skip(22)
	end
	event.EohSetTexAnim(2, 1, "歯くいしばり")
	event.SetMotionBlur(64)
	helper_ff0edc1d(21)
	if vm.skipping() then
		return skip(23)
	end
	event.SetFadeOut(3)
	helper_ff0edc1d(3)
	if vm.skipping() then
		return skip(24)
	end
	return part2()
end

--- Program 28010.
local function program_28010()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_ff0edc1d(6)
		end
		helper_1770(0.0, 0.0, 300.0, 0.0)
	end
	event.Initialize()
	event.SetFadeOut(0)
	if vm.wait() then
		return skip(1)
	end
	event.StopBgm(0)
	helper_ff0edc1d(6)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(107)
	event.PlayBgm(0)
	event.LoadMonsterFile(628, 1)
	event.LoadMonsterFile(1006, 0)
	event.AutoSetMonster(628, 0.0, 0.0, 800.0, 0.0, 3.14, 0.0)
	helper_1770(0.0, 0.0, 300.0, 0.0)
	event.SetCameraRef(0.0, 30.0, 300.0)
	event.SetCameraPos(0.0, 40.0, 180.0)
	event.ResetCamera(0)
	event.SetFadeIn(30)
	event.Finish()
end

--- Helper function.
local function helper_13e98()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 16 then
			if at <= 1 then
				helper_1d96573f(8120010)
			end
			if at <= 2 then
				helper_1d96573f(8120015)
			end
			if at <= 3 then
				helper_1d96573f(8120020)
			end
			if at <= 4 then
				helper_650bfa16(1)
			end
			if at <= 5 then
				helper_1d96573f(8120030)
			end
			if at <= 6 then
				helper_650bfa16(0)
			end
			if at <= 7 then
				helper_1d96573f(8120040)
			end
			if at <= 8 then
				helper_1d96573f(8120045)
			end
			if at <= 9 then
				helper_650bfa16(2)
			end
			if at <= 10 then
				helper_076280e8()
			end
			if at <= 11 then
				helper_ff0edc1d(10)
			end
			if at <= 12 then
				helper_ff0edc1d(30)
			end
			if at <= 13 then
				helper_1d96573f(8120050)
			end
			if at <= 14 then
				helper_1d96573f(8120060)
			end
			if at <= 15 then
				helper_ff0edc1d(30)
			end
			if vm.skip_end() then
				return skip(17)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.SndSeStop(var1, 0)
		event.SndSeStop(var1, 1)
		event.DelExtMotion(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.LoadMes(0, -1)
		event.SetStatusbarShow(1, 1.0)
		event.SetCharaShow(1, 1)
		event.SetCharaShow(2, 1)
		event.Finish()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(812, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.LoadSound(8806)
	var1 = event.SndLoadSound(8806) or var1
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e800/e812/")
	event.LoadMes(0, 5, "e812.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e812_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e812_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e812_m_polcurse.gltf", "info", 10)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e812_mp_bakuha.gltf", "info", 11)
	event.CharaActive(0, 11)
	event.LoadChara(5, "e812_mp_biribiri.gltf", "info", 12)
	event.CharaActive(12)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 8)
		event.LoadEquip(5, 0, 4, "info", 8)
		event.LoadEquip(5, 0, 3, "info", 8)
		event.LoadEquip(5, 0, 2, "info", 8, 9)
		event.LoadMotion(5, "event/e800/e812/e812_mints.gltf", "info", 8)
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
		event.LoadMotion(5, "event/e800/e812/e812_monica.gltf", "info", 8)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 8)
		event.EohSyncChara(1, 8)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(8)
	event.CharaActive(9)
	event.SetCharaShow(1, 0)
	event.SetCharaShow(2, 0)
	event.EohSetPos(0, 8.0, 0.0, 100.0)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 16)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "無表情")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetPos(1, -8.0, 0.0, 100.0)
	event.EohSetRot(1, 0.0, 0.0, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetFootSoundId(1, 16)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "あきれ顔")
	event.EohSetTexAnim(1, 1, "あきれ目パチ")
	event.EohSetPos(2, 0.0, 0.0, 400.0)
	event.EohSetRot(2, 0.0, 3.14, 0.0)
	event.EohSetMotion(2, "ガクガク", 4)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "くやし顔")
	event.EohSetTexAnim(2, 1, "やられ目パチ")
	event.SetCharaPos(12, 0.0, 0.0, 400.0)
	event.SetCharaRot(12, 0.0, 3.14, 0.0)
	event.SetCharaPos(11, 0.0, 0.0, 400.0)
	event.SetCharaRot(11, 0.0, 3.14, 0.0)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(0.0, 20.91, 290.09)
	event.CmrsSetRef(0.0, 17.6, 396.09)
	event.SndSePlay(var1, 0)
	event.SetFadeIn(30)
	event.SetPakuAnim(2, "やられ口パク")
	helper_1d96573f(8120010)
	if vm.skipping() then
		return skip(2)
	end
	event.SetPakuAnim(2, "やられ口パク")
	helper_1d96573f(8120015)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsSetPos(-21.92, 23.66, 134.75)
	event.CmrsSetRef(-4.36, 20.87, 105.83)
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_1d96573f(8120020)
	if vm.skipping() then
		return skip(4)
	end
	helper_650bfa16(1)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(0, "うなづく", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_1d96573f(8120030)
	if vm.skipping() then
		return skip(6)
	end
	helper_650bfa16(0)
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsSetPos(-27.34, 30.34, 365.86)
	event.CmrsSetRef(-0.39, 25.21, 399.29)
	event.ObjsSetMotion(2, "きっと・・・", 4)
	event.SetPakuAnim(2, "やられ口パク")
	helper_1d96573f(8120040)
	if vm.skipping() then
		return skip(8)
	end
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "わらい顔")
	event.CmrsMove2(-125.62, 18.68, 243.92, -0.39, 25.21, 399.29, 60, 0, 0.2)
	event.ObjsSetMotion(2, "ポーズ", 6)
	event.ObjsNextMotion(2, "ポーズＬ", 4)
	event.SetPakuAnim(2, "やられ口パク")
	helper_1d96573f(8120045)
	if vm.skipping() then
		return skip(9)
	end
	helper_650bfa16(2)
	if vm.skipping() then
		return skip(10)
	end
	helper_076280e8()
	if vm.skipping() then
		return skip(11)
	end
	event.SndSeStop(var1, 0)
	event.SndSePlay(var1, 1)
	event.CharaActive(1, 11)
	event.SetMotion(11, "MP爆発", 6)
	helper_ff0edc1d(10)
	if vm.skipping() then
		return skip(12)
	end
	event.SetCharaShow(10, 0, 1, 0.1)
	event.SetCharaShow(12, 0, 1, 0.1)
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(13)
	end
	event.CmrsSetPos(-91.42, 22.7, -33.42)
	event.CmrsSetRef(-1.04, 13.67, 105.35)
	event.SetCharaPos(11, -105.44, 0.0, 185.46)
	event.SetCharaRot(11, 0.0, -2.78, 0.0)
	event.ObjsSetMotion(1, "左向く", 6)
	event.ObjsNextMotion(1, "左向く会話", 6)
	event.ObjsNextMotion(1, "左向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_1d96573f(8120050)
	if vm.skipping() then
		return skip(14)
	end
	event.ObjsSetMotion(0, "右向く", 6)
	event.ObjsNextMotion(0, "右くL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_1d96573f(8120060)
	if vm.skipping() then
		return skip(15)
	end
	event.SetFadeOut(30)
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(16)
	end
	return part2()
end

--- Helper function.
local function helper_c63c(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b7c85616(1, 4)
			helper_34727ca1(1, vm.i32(60 + arg0), 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_b7c85616(1, 4)
	helper_34727ca1(1, vm.i32(60 + arg0), 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_db48(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local boss_map: s32 = 0
	local var4: s32 = 0
	local argc: s32 = 0
	local battle_bgm_vol: s32 = 0
	local active_chr_no: s32 = 0
	local var8: s32 = 0
	local block: s32 = 0
	local var10: s32 = 0
	local debug_flag: s32 = 0
	local load_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 16 then
			if at <= 1 then
				print("---------------------------------------------BATTLE BGM STOP\n")
				var8 = 0
				helper_ff0edc1d(30)
			end
			if at <= 2 then
				helper_4575bf67()
			end
			if at <= 3 then
				helper_ff0edc1d(30)
			end
			if at <= 4 then
				helper_ac1aeb7a(arg1, -1)
			end
			if at <= 5 then
				helper_ff0edc1d(10)
			end
			if at <= 6 then
				helper_ff0edc1d(30)
			end
			if at <= 7 then
				helper_ff0edc1d(120)
			end
			if at <= 8 then
				local _ = helper_79e692b8(0)
			end
			if at <= 9 then
				helper_c63c(1)
			end
			if at <= 10 then
				helper_c63c(4)
			end
			if at <= 11 then
				helper_c63c(active_chr_no)
			end
			if at <= 12 then
				helper_c63c(1)
			end
			if at <= 13 then
				helper_ff0edc1d(30)
			end
			if at <= 15 then
				helper_ff0edc1d(30)
			end
			return 1
		end
		print("---------------------------------------------DEAD RELOAD_BGM = ", load_no, "\n")
		print("---------------------------------------------BOSS BATTLE = ", boss_map, "\n")
		print("---------------------------------------------PAUSE BATTLE BGM = ", var2, "\n")
		print("---------------------------------------------BATTLE BGM PLAY\n")
		return 0
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.AssignStack(5)
	event.ClearStack(5)
	var2 = event.DngCheckPause(16384) or var2
	if var2 ~= 16384 then
		event.DngPause(16384, 1)
	end
	boss_map = event.DngCheckBossMap() or boss_map
	event.GetActiveBgmStatus(-1)
	if var2 ~= 16384 and boss_map ~= 1 then
		var4 = event.GetEventInfoSndid(4) or var4
		argc = event.GetSeStatus(var4, 0) or argc
		battle_bgm_vol = event.GetBtlBgmVol() or battle_bgm_vol
		event.SndSeStop(var4, 0)
		print("---------------------------------------------BATTLE BGM STOP\n")
	end
	event.StopBgm(0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 or active_chr_no == 1 then
		event.SetTexAnim(0, 0, "目パチ")
		event.SetTexAnim(0, 1, "死に")
	end
	if active_chr_no == 2 then
		event.ActchrSetMotion(0, "故障", 6)
		event.EsmInitialize(5, 1)
		event.EsmLoadBase("ロボ故障")
		event.EsmInitFix(5)
		event.EsmCreate("ロボ故障")
	end
	var8 = 0
	if active_chr_no == 2 then
		var8 = event.CheckEnableCharaChange(0) or var8
		if var8 == 0 then
			var8 = event.CheckEnableCharaChange(1) or var8
		end
	end
	if active_chr_no == 0 then
		var8 = event.CheckEnableCharaChange(1) or var8
	end
	if active_chr_no == 1 then
		var8 = event.CheckEnableCharaChange(0) or var8
	end
	if active_chr_no == 3 then
		var8 = event.CheckEnableCharaChange(1) or var8
		if var8 == 0 then
			var8 = event.CheckEnableCharaChange(0) or var8
		end
	end
	event.SetLoadbgFile("snd2/bgm/bg_060.sound.json", "textures/dungeon/image/gameover.json")
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(2)
	end
	event.SetStatusbarShow(0, 0.06666667)
	helper_4575bf67()
	if vm.skipping() then
		return skip(3)
	end
	event.LoadBgmPack(60)
	if var8 == 1 or var8 ~= 1 and arg1 < 0 then
		event.PlayBgm(0)
	end
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(4)
	end
	event.DngPause(1, 1)
	event.DngCollisionAllClr()
	if var8 ~= 1 then
		block = event.LoadImg_4(5, "textures/dungeon/image/gameover.json", 1) or block
		if arg1 >= 0 then
			helper_ac1aeb7a(arg1, -1)
			if vm.skipping() then
				return skip(5)
			end
			helper_ff0edc1d(10)
			if vm.skipping() then
				return skip(6)
			end
			event.PlayBgm(0)
		end
		event.SpriteInit(0)
		event.SpriteSetType(0, 0)
		event.SpriteSetTexture(0, "gameover1", block)
		event.SpriteSetColor(0, 128, 128, 128, 128)
		event.SpriteSetUvsize(0, 0, 0, 576, 128)
		event.SpriteSetPutsize(0, 576, 128)
		event.SpriteSetPos(0, -320, 208)
		event.SpriteSetDraw(0, 1)
		event.EohSyncSprite(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsMove(0, 288, 208, 0.0, 20)
		helper_ff0edc1d(30)
		if vm.skipping() then
			return skip(7)
		end
		event.SpriteInit(1)
		event.SpriteSetType(1, 0)
		event.SpriteSetTexture(1, "gameover1", block)
		event.SpriteSetColor(1, 128, 128, 128, 0)
		event.SpriteSetUvsize(1, 0, 128, 576, 64)
		event.SpriteSetPutsize(1, 576, 64)
		event.SpriteSetPos(1, 256, 208)
		event.SpriteSetDraw(1, 1)
		event.EohSyncSprite(1, 1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.ObjsSetColor(1, 128, 128, 128, 128, 120)
		helper_ff0edc1d(120)
		if vm.skipping() then
			return skip(8)
		end
		while true do
			if helper_79e692b8(0) ~= 0 then
				break
			end
			if vm.wait() then
				return skip(9)
			end
		end
	elseif active_chr_no == 3 then
		var10 = event.CheckEnableCharaChange(1) or var10
		if var10 == 0 then
			helper_c63c(1)
			if vm.skipping() then
				return skip(10)
			end
		else
			helper_c63c(4)
			if vm.skipping() then
				return skip(11)
			end
		end
	elseif active_chr_no == 0 or active_chr_no == 2 then
		helper_c63c(active_chr_no)
		if vm.skipping() then
			return skip(12)
		end
	else
		helper_c63c(1)
		if vm.skipping() then
			return skip(13)
		end
	end
	debug_flag = event.GetDebugFlag() or debug_flag
	if debug_flag == 1 then
		event.DngDebugCommand(0)
		event.AddWhp(0, 999)
		event.AddWhp(1, 999)
		if active_chr_no == 2 then
			event.EsmClear()
		end
		if active_chr_no == 0 or active_chr_no == 1 then
			event.SetTexAnim(0, 0, "死に")
			event.SetTexAnim(0, 1, "目パチ")
		end
		event.ActchrSetDefMotion(0, 4)
	elseif var8 == 1 then
		event.SetFadeOut(30)
		helper_ff0edc1d(30)
		if vm.skipping() then
			return skip(14)
		end
		if active_chr_no == 2 then
			event.EsmClear()
		end
		event.MenuCharaChenge(-1)
		if vm.wait() then
			return skip(15)
		end
		event.SetFadeOut(0)
	else
		event.FadeOutBgm(30)
		event.SetFadeOut(30)
		helper_ff0edc1d(30)
		if vm.skipping() then
			return skip(16)
		end
		if active_chr_no == 2 then
			event.EsmClear()
		end
		event.StopBgm(0)
		event.SpriteSetDraw(0, 0)
		event.SpriteSetDraw(1, 0)
		event.DelImg(1)
		if arg0 == 1 then
			event.AddHpRate(1.0, 0)
			event.AddWhp(0, 999)
			event.AddWhp(1, 999)
			event.DngRunEvent(-1)
			event.DelMonster(-1)
			event.DngPause(1, 0)
			event.Finish()
			return 1
		else
			event.SetExitFlag(1)
			event.Finish()
			return 0
		end
	end
	event.StopBgm(0)
	helper_ff0edc1d(4)
	if vm.skipping() then
		return skip(17)
	end
	load_no = event.GetBgmStatusNowNo() or load_no
	event.LoadBgm(load_no)
	print("---------------------------------------------DEAD RELOAD_BGM = ", load_no, "\n")
	print("---------------------------------------------BOSS BATTLE = ", boss_map, "\n")
	print("---------------------------------------------PAUSE BATTLE BGM = ", var2, "\n")
	event.SetActiveBgmStatus(-1)
	event.SpriteSetDraw(0, 0)
	event.SpriteSetDraw(1, 0)
	event.DelImg(1)
	if var2 ~= 16384 and boss_map ~= 1 then
		if argc == 1 then
			print("---------------------------------------------BATTLE BGM PLAY\n")
			event.SndSePlay(var4, 0)
			event.SndSetSeVol(var4, 0, battle_bgm_vol)
		end
	end
	event.SetCameraCtrl(1)
	event.SetStatusbarShow(1, 1.0)
	if debug_flag ~= 1 then
		event.SetFadeIn(10)
	end
	if var2 ~= 16384 then
		event.DngPause(16385, 0)
	else
		event.DngPause(1, 0)
	end
	event.Finish()
	return 0
end

--- Helper function.
local function helper_feac(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		return helper_db48(arg0, arg1)
	end
	if vm.skipping() then
		return skip(1)
	end
	return helper_db48(arg0, arg1)
end

--- Helper function.
local function helper_fe14(arg0: s32)
	return helper_db48(arg0, -1)
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script[99] = program_99

--- Program 100.
script[100] = function()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		helper_1770(0.0, 0.0, 300.0, 0.0)
	end
	program_99()
	helper_1770(0.0, 0.0, 0.0, 0.0)
	event.SetCameraRef(0.0, 30.0, 0.0)
	event.SetCameraPos(0.0, 40.0, -120.0)
	event.ResetCamera(0)
	flag = event.GetFlag(808) or flag
	if flag == 0 then
		helper_10690()
		if vm.skipping() then
			return skip(1)
		end
		event.SetBitCtrl(1, 1)
		if vm.wait() then
			return skip(2)
		end
		helper_1770(0.0, 0.0, 300.0, 0.0)
		event.SetCameraRef(0.0, 30.0, 300.0)
		event.SetCameraPos(0.0, 40.0, 180.0)
		event.ResetCamera(0)
		event.LoadMonsterFile(628, 1)
		event.LoadMonsterFile(1006, 0)
		event.AutoSetMonster(628, 0.0, 0.0, 800.0, 0.0, 3.14, 0.0)
	end
	event.SetFadeIn(30)
	event.Finish()
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_868b9caa(32)
		end
	end
	if vm.wait() then
		return skip(1)
	end
	helper_868b9caa(32)
	if vm.skipping() then
		return skip(2)
	end
end

--- Program 151.
script[151] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	program_28010()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 300.
script[300] = function()
	local active_chr_no: s32 = 0
	local var1: any = 0
	local stage_id: s32 = 0
	local var3: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_34727ca1(0, 21, 5, 256, 208)
			end
			return
		end
		if at <= 3 then
			helper_ff0edc1d(30)
		end
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 1)
		if active_chr_no == 2 then
			helper_34727ca1(0, 20, 5, 256, 208)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_34727ca1(0, 21, 5, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		end
		event.Finish()
		return
	end
	event.SetMesQuestionGyou(0, 0)
	event.SetMesWindowMode(0, 5)
	event.SetMesDrawspeed(0, 1)
	var1 = helper_582dcd42(0, 10, 8, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(3)
	end
	if var1 == 0 then
		event.SetFadeOut(30)
		helper_ff0edc1d(30)
		if vm.skipping() then
			return skip(4)
		end
		stage_id = event.DngGetStageId() or stage_id
		var3 = event.DngGetFloorId() or var3
		argc = event.GetNextFloor(var3, 0) or argc
		event.DngSetFloorId(argc)
		event.SetFloorInfo(stage_id, var3, 5, 2)
		event.SetFloorInfo(stage_id, argc, 5, 1)
		event.LoadScript("d07/d07.stb", 1000)
	else
		event.Finish()
	end
end

--- Program 500.
script[500] = function()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_13e98()
			if not vm.skipping() then
				return part2()
			end
		end
		helper_ff38()
		helper_1770(0.0, 0.0, 700.0, 0.0)
	end
	function part2()
		event.SetBitCtrl(1, 0)
		helper_ff38()
		helper_1770(0.0, 0.0, 700.0, 0.0)
		event.SetCameraRef(0.0, 30.0, 700.0)
		event.SetCameraPos(0.0, 40.0, 580.0)
		event.ResetCamera(0)
		event.SetFadeIn(30)
		event.Finish()
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	event.FadeOutBgm(20)
	event.SetFadeOut(20)
	helper_ff0edc1d(20)
	if vm.skipping() then
		return skip(1)
	end
	event.StopBgm(0)
	event.DelMonster(-1)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 then
		event.DngSetupMainUnit(0)
	end
	if active_chr_no == 3 then
		event.DngSetupMainUnit(1)
	end
	helper_13e98()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 1200.
script[1200] = function()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local value: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_feac(0, 8590070)
			end
			return
		end
	end
	flag = event.GetFlag(808) or flag
	flag_2 = event.GetFlag(812) or flag_2
	if flag ~= 0 and flag_2 == 0 then
		value = 0
		value = event.GetRandInt(100) or value
		if value < 50 then
			helper_feac(0, 8590060)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_feac(0, 8590070)
			if vm.skipping() then
				return skip(2)
			end
		end
		return
	end
	helper_fe14(0)
	if vm.skipping() then
		return skip(3)
	end
end

--- Program 18080.
script[18080] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	program_99()
	helper_10690()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 18120.
script[18120] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	program_99()
	helper_13e98()
	if vm.skipping() then
		return skip(1)
	end
end

script[28010] = program_28010

return script
