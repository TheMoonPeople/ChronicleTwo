--!strict
-- map/d/d07/b01/d07b01.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_09fd1f10 = require("@lib/event/helper_09fd1f10")
local helper_31a4c001 = require("@lib/event/helper_31a4c001")
local helper_3a74ecc4 = require("@lib/event/helper_3a74ecc4")
local helper_4be4f575 = require("@lib/event/helper_4be4f575")
local helper_4d0c9edd = require("@lib/event/helper_4d0c9edd")
local helper_56a731b3 = require("@lib/event/helper_56a731b3")
local helper_6dfa44e2 = require("@lib/event/helper_6dfa44e2")
local helper_71fa1d07 = require("@lib/event/helper_71fa1d07")
local helper_73d6f64a = require("@lib/event/helper_73d6f64a")
local helper_73f3f94a = require("@lib/event/helper_73f3f94a")
local helper_7841320d = require("@lib/event/helper_7841320d")
local helper_7a5e82c7 = require("@lib/event/helper_7a5e82c7")
local helper_91637685 = require("@lib/event/helper_91637685")
local helper_d9c15850 = require("@lib/event/helper_d9c15850")

--- Program 99.
local function program_99()
	local flag: s32 = 0
	event.StopBgm(0)
	event.LoadSound(8693)
	flag = event.GetFlag(820) or flag
	if flag == 1 then
		event.EohSyncObj(0, "p04")
		event.EohSetShow(0, 0)
		event.FuncPointShow("p04", "func", 0)
	end
end

--- Program 28020.
local function program_28020()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_4d0c9edd(vm.f32(438.61), 0.0, vm.f32(192.19), vm.f32(-1.89))
		end
	end
	event.Initialize()
	event.SetFadeOut(0)
	event.EohSyncObj(0, "p06")
	event.EohSetShow(0, 1)
	event.StopBgm(0)
	helper_6dfa44e2(6)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(40)
	event.PlayBgm(0)
	event.LoadMonsterFile(629, 1)
	event.LoadMonsterFile(630, 0)
	event.AutoSetMonster(629, -513.2, 9.0, -127.2, 0.0, 1.25, 0.0)
	helper_4d0c9edd(vm.f32(438.61), 0.0, vm.f32(192.19), vm.f32(-1.89))
	event.SetCameraRef(438.61, 30.0, 192.19)
	event.SetCameraPos(590.29, 39.11, 243.1)
	event.ResetCamera(0)
	event.SetFadeIn(30)
	if vm.wait() then
		return skip(2)
	end
	event.Finish()
end

--- Helper function.
local function helper_d04(arg0: s32)
	local get_pad_down: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return vm.i32(bit32.band(get_pad_down, arg0))
	end
	if vm.skipping() then
		return skip(1)
	end
	get_pad_down = event.GetPaddown() or get_pad_down
	return vm.i32(bit32.band(get_pad_down, arg0))
end

--- Helper function.
local function helper_f08(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_d04(arg0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	while true do
		if helper_d04(arg0) ~= 0 then
			break
		else
			if vm.wait() then
				return skip(2)
			end
		end
	end
end

--- Helper function.
local function helper_8394(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32, arg5: s32)
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		helper_09fd1f10(arg0)
		return arg5
	end
	local _ = helper_91637685(arg0, arg1, arg2, arg3, arg4)
	_, arg5 = helper_56a731b3(arg0, 1, arg5)
	if vm.skipping() then
		return skip(1)
	end
	helper_09fd1f10(arg0)
	return arg5
end

--- Helper function.
local function helper_10694()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local block: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 38 then
			if at <= 1 then
				helper_6dfa44e2(6)
			end
			if at <= 2 then
				helper_6dfa44e2(20)
			end
			if at <= 3 then
				helper_6dfa44e2(50)
			end
			if at <= 4 then
				helper_6dfa44e2(10)
			end
			if at <= 5 then
				helper_6dfa44e2(40)
			end
			if at <= 6 then
				helper_d9c15850(0)
			end
			if at <= 7 then
				helper_d9c15850(0)
			end
			if at <= 8 then
				helper_71fa1d07()
			end
			if at <= 9 then
				helper_71fa1d07()
			end
			if at <= 10 then
				helper_6dfa44e2(30)
			end
			if at <= 11 then
				helper_4be4f575(8160010)
			end
			if at <= 12 then
				helper_4be4f575(8160015)
			end
			if at <= 13 then
				helper_4be4f575(8160020)
			end
			if at <= 14 then
				helper_d9c15850(0)
			end
			if at <= 15 then
				helper_6dfa44e2(20)
			end
			if at <= 16 then
				helper_4be4f575(8160030)
			end
			if at <= 17 then
				helper_4be4f575(8160035)
			end
			if at <= 18 then
				helper_6dfa44e2(10)
			end
			if at <= 19 then
				helper_6dfa44e2(20)
			end
			if at <= 20 then
				helper_6dfa44e2(20)
			end
			if at <= 21 then
				helper_71fa1d07()
			end
			if at <= 22 then
				helper_6dfa44e2(30)
			end
			if at <= 23 then
				helper_6dfa44e2(10)
			end
			if at <= 24 then
				helper_4be4f575(8160040)
			end
			if at <= 25 then
				helper_4be4f575(8160050)
			end
			if at <= 26 then
				helper_4be4f575(8160060)
			end
			if at <= 27 then
				helper_4be4f575(8160070)
			end
			if at <= 28 then
				helper_4be4f575(8160080)
			end
			if at <= 29 then
				helper_4be4f575(8160090)
			end
			if at <= 30 then
				helper_71fa1d07()
			end
			if at <= 31 then
				helper_d9c15850(2)
			end
			if at <= 32 then
				helper_4be4f575(8160100)
			end
			if at <= 33 then
				helper_4be4f575(8160105)
			end
			if at <= 34 then
				helper_4be4f575(8160110)
			end
			if at <= 35 then
				helper_4be4f575(8160120)
			end
			if at <= 36 then
				helper_d9c15850(2)
			end
			if at <= 37 then
				helper_6dfa44e2(30)
			end
			if vm.skip_end() then
				return skip(39)
			end
			return part2()
		end
		if at <= 39 then
			helper_6dfa44e2(6)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var1, 0)
		event.SndSeStop(var1, 1)
		event.SndSeStop(var1, 2)
		event.SndSeStop(var1, 3)
		event.SndSeStop(var1, 4)
		event.SndSeStop(var1, 5)
		event.EohSetShow(4, 0)
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
		event.DelImg(0)
		event.LoadMes(0, -1)
		event.CharaActive(1, 0)
		event.StopBgm(0)
		helper_6dfa44e2(6)
		if vm.skipping() then
			return skip(40)
		end
		event.LoadBgm(40)
		event.PlayBgm(0)
		event.SetStatusbarShow(1, 1.0)
		event.SetCharaShow(1, 1)
		event.SetCharaShow(2, 1)
		event.Finish()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(816, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.StopBgm(0)
	helper_6dfa44e2(6)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(111)
	event.PlayBgm(0)
	event.LoadSound(8809)
	var1 = event.SndLoadSound(8809) or var1
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e800/e816/")
	event.LoadMes(0, 5, "e816.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e816_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e816_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e816_majin.gltf", "info", 10)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	block = event.LoadImg_4(5, "e816telop01.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e816telop01", block)
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
		event.LoadMotion(5, "event/e800/e816/e816_mints.gltf", "info", 8)
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
		event.LoadMotion(5, "event/e800/e816/e816_monica.gltf", "info", 8)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 8)
		event.EohSyncChara(1, 8)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(8)
	event.CharaActive(9)
	event.LoadChara(5, "event/e200/e206/e206_bbaku.gltf", "info", 11)
	event.CharaActive(0, 11)
	event.EohSyncObj(4, "p04")
	event.SetCharaShow(1, 0)
	event.SetCharaShow(2, 0)
	event.EohSetShow(4, 1)
	event.EohSetPos(0, 772.29, -72.1, 1522.76)
	event.EohSetRot(0, 0.0, -2.64, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 2)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetPos(1, 0.0, 0.0, 0.0)
	event.EohSetRot(1, 0.0, 0.0, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetFootSoundId(1, 2)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.EohSetPos(2, 0.0, -1000.0, 0.0)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetScale(2, 8.0, 8.0, 8.0)
	event.SetCharaPos(11, 974.5, 0.34, 1616.44)
	event.SetCharaRot(11, 0.0, 1.32, 0.0)
	event.SetScale(11, 1.0, 1.0, 1.0)
	if active_chr_no == 0 then
		event.CharaActive(0, 8)
		event.CharaActive(0, 9)
	else
		event.CharaActive(0, 0)
	end
	event.InitDramaScene()
	event.ObjsPosDelay(0, 20)
	event.ObjsMove(0, 850.58, -72.1, 1669.29, 40)
	event.ObjsRotDelay(0, 20)
	event.ObjsRotation(0, 0.0, 0.52, 0.0, 8)
	event.ObjsMotionDelay(0, 20)
	event.ObjsSetMotion(0, "走り")
	event.ObjsMotionDelay(0, 40)
	event.ObjsSetMotion(0, "立ち")
	event.CmrsInit()
	event.CmrsSetPos(988.97, 77.53, 1641.42)
	event.CmrsSetRef(768.43, -42.14, 1535.48)
	event.SetFadeIn(30)
	helper_6dfa44e2(20)
	if vm.skipping() then
		return skip(3)
	end
	event.SndSePlay(var1, 0)
	helper_6dfa44e2(50)
	if vm.skipping() then
		return skip(4)
	end
	event.SndSeStop(var1, 0)
	event.SndSePlay(var1, 1)
	event.CmrsQuake2(0.0, 1.0, 0.0, 50)
	event.CharaActive(11)
	event.SetMotion(11, "ｴﾌｪｸﾄ_バギー爆発", 6)
	helper_6dfa44e2(10)
	if vm.skipping() then
		return skip(5)
	end
	event.EohSetShow(4, 0)
	event.ObjsSetRot(0, 0.0, -2.6, 0.0)
	helper_6dfa44e2(40)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsMove(0, 805.68, -72.1, 1578.18, 90)
	event.ObjsSetMotion(0, "歩き")
	helper_d9c15850(0)
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsSetPos(526.21, 180.7, 925.23)
	event.CmrsSetRef(591.71, 28.27, 1249.82)
	if active_chr_no == 0 then
		event.CharaActive(1, 8)
		event.CharaActive(1, 9)
	else
		event.CharaActive(1, 0)
	end
	event.ObjsSetPos(0, 647.7, -69.42, 1336.0)
	event.ObjsSetRot(0, 0.0, -2.48, 0.0)
	event.ObjsMove(0, 594.08, -64.59, 1267.87, 90)
	event.ObjsMotionDelay(0, 90)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsSetPos(1, 642.51, -70.56, 1362.06)
	event.ObjsSetRot(1, 0.0, -2.6, 0.0)
	event.ObjsMove(1, 586.91, -65.57, 1291.72, 90)
	event.ObjsSetMotion(1, "歩き", 4, -1.0, 1)
	event.ObjsMotionDelay(1, 90)
	event.ObjsSetMotion(1, "立ち")
	helper_d9c15850(0)
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsSetPos(680.66, 6.68, 980.64)
	event.CmrsSetRef(575.95, -0.27, 930.94)
	event.CmrsMove2(680.66, 6.68, 980.64, 608.93, 31.74, 882.58, 40, 0, 0.4)
	helper_71fa1d07()
	if vm.skipping() then
		return skip(9)
	end
	event.CmrsMove2(680.66, 6.68, 980.64, 576.22, 34.02, 919.65, 14, 2, 0.2)
	helper_71fa1d07()
	if vm.skipping() then
		return skip(10)
	end
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(577.41, -36.52, 1231.62)
	event.CmrsSetRef(593.55, -49.69, 1286.96)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目～おどろき目")
	event.ObjsSetMotion(0, "指さす", 6)
	event.ObjsNextMotion(0, "指さすL", 4)
	event.ObjsSeDelay(0, 10)
	event.ObjsSePlay(0, var1, 2)
	event.SetPakuAnim(0, "通常口パク")
	helper_4be4f575(8160010)
	if vm.skipping() then
		return skip(12)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_4be4f575(8160015)
	if vm.skipping() then
		return skip(13)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_4be4f575(8160020)
	if vm.skipping() then
		return skip(14)
	end
	helper_d9c15850(0)
	if vm.skipping() then
		return skip(15)
	end
	event.CmrsSetPos(-175.42, 20.69, 292.74)
	event.CmrsSetRef(-130.55, 18.84, 404.37)
	event.FadeOutBgm(60)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.ObjsSetPos(0, 30.86, -3.88, 469.02)
	event.ObjsSetRot(0, 0.0, -2.12, 0.0)
	event.ObjsMove(0, -163.18, 0.0, 334.91, 50)
	event.ObjsSetMotion(0, "走り", 4)
	event.ObjsMotionDelay(0, 50)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsMotionDelay(0, 6)
	event.ObjsSetMotion(0, "キョロキョロ", 4)
	event.ObjsTexaDelay(0, 30)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目～おどろき目")
	event.ObjsTexAnime(0, 1, "半口")
	event.ObjsSetPos(1, 73.45, -7.05, 525.46)
	event.ObjsSetRot(1, 0.0, -2.12, 0.0)
	event.ObjsMove(1, -116.94, 0.0, 392.73, 60)
	event.ObjsRotDelay(1, 50)
	event.ObjsRotation(1, 0.0, 2.84, 0.0, 10)
	event.ObjsSetMotion(1, "走り", 4)
	event.ObjsMotionDelay(1, 60)
	event.ObjsSetMotion(1, "立ち")
	event.ObjsTexaDelay(1, 30)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsTexAnime(1, 1, "半口")
	helper_6dfa44e2(20)
	if vm.skipping() then
		return skip(16)
	end
	helper_4be4f575(8160030)
	if vm.skipping() then
		return skip(17)
	end
	helper_4be4f575(8160035)
	if vm.skipping() then
		return skip(18)
	end
	event.CmrsSetPos(57.5, 40.21, 529.52)
	event.CmrsSetRef(-184.49, 8.41, 336.31)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetPos(1, -182.92, 0.0, 359.09)
	event.ObjsSetRot(1, 0.0, -2.36, 0.0)
	event.ObjsSetPos(2, -367.65, 0.0, 193.54)
	event.ObjsSetRot(2, 0.0, 0.9, 0.0)
	event.ObjsSetMotion(2, "ふってくる", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.SndSePlay(var1, 3)
	helper_6dfa44e2(10)
	if vm.skipping() then
		return skip(19)
	end
	event.ObjsSetMotion(0, "ドスン", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.ObjsSetMotion(1, "着地振動", 6)
	event.ObjsNextMotion(1, "上向くL", 4)
	event.CmrsQuake(0.0, 8.0, 0.0, 40)
	helper_6dfa44e2(20)
	if vm.skipping() then
		return skip(20)
	end
	event.CmrsMove2(57.5, 40.21, 529.52, -184.49, 99.45, 336.31, 60, 0, 0.2)
	helper_6dfa44e2(20)
	if vm.skipping() then
		return skip(21)
	end
	event.SpriteSetDraw(0, 1)
	event.ObjsSetColor(3, 128, 128, 128, 128, 20)
	helper_71fa1d07()
	if vm.skipping() then
		return skip(22)
	end
	event.ObjsSetColor(3, 128, 128, 128, 0, 30)
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(23)
	end
	event.SpriteSetDraw(0, 0)
	helper_6dfa44e2(10)
	if vm.skipping() then
		return skip(24)
	end
	event.CmrsSetPos(-201.98, 60.97, 306.62)
	event.CmrsSetRef(-164.55, 1.55, 356.48)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "無表情")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.SetPakuAnim(1, "通常口パク")
	helper_4be4f575(8160040)
	if vm.skipping() then
		return skip(25)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_4be4f575(8160050)
	if vm.skipping() then
		return skip(26)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_4be4f575(8160060)
	if vm.skipping() then
		return skip(27)
	end
	event.CmrsSetRef(-332.71, 270.78, 221.57)
	event.CmrsSetAhd(0.43, -34.0, 115.0)
	event.CmrsMoveAhd2(1.54, -34.0, 115.0, 200, 0, 0.2)
	event.SetPakuMotion(2, "会話", 0, "立ち", 0)
	helper_4be4f575(8160070)
	if vm.skipping() then
		return skip(28)
	end
	event.SetPakuMotion(2, "会話", 0, "立ち", 0)
	helper_4be4f575(8160080)
	if vm.skipping() then
		return skip(29)
	end
	event.SetPakuMotion(2, "会話", 0, "立ち", 0)
	helper_4be4f575(8160090)
	if vm.skipping() then
		return skip(30)
	end
	helper_71fa1d07()
	if vm.skipping() then
		return skip(31)
	end
	event.CmrsSetPos(-314.29, 515.61, 172.37)
	event.CmrsSetRef(-286.23, 270.78, 236.95)
	event.SndSePlay(var1, 4)
	event.ObjsSetMotion(2, "覗き込み会話", 6)
	event.ObjsMotionWait(2)
	helper_d9c15850(2)
	if vm.skipping() then
		return skip(32)
	end
	event.SetPakuMotion(2, "覗き込み会話Ｌ", 4, "覗き込み会話とまり", 0)
	helper_4be4f575(8160100)
	if vm.skipping() then
		return skip(33)
	end
	event.SetPakuMotion(2, "覗き込み会話Ｌ", 0, "覗き込み会話とまり", 0)
	helper_4be4f575(8160105)
	if vm.skipping() then
		return skip(34)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_4be4f575(8160110)
	if vm.skipping() then
		return skip(35)
	end
	event.SetPakuMotion(2, "覗き込み会話Ｌ", 0, "覗き込み会話とまり", 0)
	helper_4be4f575(8160120)
	if vm.skipping() then
		return skip(36)
	end
	event.SndSePlay(var1, 5)
	event.ObjsSetMotion(2, "一歩前へ", 6)
	event.ObjsNextMotion(2, "一歩前へＬ", 4)
	helper_d9c15850(2)
	if vm.skipping() then
		return skip(37)
	end
	event.SetFadeOut(30)
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(38)
	end
	return part2()
end

--- Helper function.
local function helper_ff48()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local rot_x: f32 = 0
	local rot_y: f32 = 0
	local rot_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				var1 = 86
				var1 = 64
			end
			return
		end
		if at <= 3 then
			helper_d9c15850(0)
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
		var1 = 86
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "dungeon/chara/c02a_miss.gltf", "info", 0)
		var1 = 64
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
		local out1, out2, out3 = event.EohGetRot(0)
		rot_x = out1 or rot_x
		rot_y = out2 or rot_y
		rot_z = out3 or rot_z
	end
	do
		local out1, out2, out3 = event.GetCameraPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.ObjsReference(0, pos_x, pos_y, pos_z, 6)
	helper_d9c15850(0)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(0, "だめだめ", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.ObjsRotDelay(0, var1)
	event.ObjsRotation(0, rot_x, rot_y, rot_z, 6)
	helper_d9c15850(0)
	if vm.skipping() then
		return skip(4)
	end
	if active_chr_no == 0 or active_chr_no == 1 then
		event.DelExtMotion(0)
	end
	event.Finish()
end

--- Helper function.
local function helper_14efc()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 12 then
			if at <= 1 then
				helper_4be4f575(8200010)
			end
			if at <= 2 then
				helper_d9c15850(2)
			end
			if at <= 3 then
				helper_6dfa44e2(30)
			end
			if at <= 4 then
				helper_4be4f575(8200020)
			end
			if at <= 5 then
				helper_4be4f575(8200030)
			end
			if at <= 6 then
				helper_4be4f575(8200040)
			end
			if at <= 7 then
				helper_4be4f575(8200045)
			end
			if at <= 8 then
				helper_d9c15850(0)
			end
			if at <= 9 then
				helper_4be4f575(8200050)
			end
			if at <= 10 then
				helper_d9c15850(1)
			end
			if at <= 11 then
				helper_6dfa44e2(30)
			end
			if vm.skip_end() then
				return skip(13)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var1, 0)
		event.SpriteSetDraw(0, 0)
		event.SetMotionBlur(0)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.LoadMes(0, -1)
		event.CharaActive(1, 0)
		event.SetStatusbarShow(1, 1.0)
		event.SetCharaShow(1, 1)
		event.SetCharaShow(2, 1)
		event.Finish()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(820, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.StopBgm(0)
	event.LoadSound(8811)
	var1 = event.SndLoadSound(8811) or var1
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e800/e820/")
	event.LoadMes(0, 5, "e820.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e820_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e820_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e820_majin.gltf", "info", 10)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 8)
		event.LoadEquip(5, 0, 4, "info", 8)
		event.LoadEquip(5, 0, 3, "info", 8)
		event.LoadEquip(5, 0, 2, "info", 8, 9)
		event.LoadMotion(5, "event/e800/e816/e816_mints.gltf", "info", 8)
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
		event.LoadMotion(5, "event/e800/e816/e816_monica.gltf", "info", 8)
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
	event.EohSetPos(0, -125.17, 0.0, -85.85)
	event.EohSetRot(0, 0.0, -1.68, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 2)
	event.EohSetPos(1, -128.34, 0.0, -68.5)
	event.EohSetRot(1, 0.0, -1.92, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetFootSoundId(1, 2)
	event.EohSetPos(2, -352.78, 0.0, -122.42)
	event.EohSetRot(2, 0.0, 0.72, 0.0)
	event.EohSetScale(2, 8.0, 8.0, 8.0)
	event.InitDramaScene()
	event.ObjsSetMotion(2, "縮む", 6)
	event.ObjsMotionWait(2)
	event.CmrsInit()
	event.CmrsSetPos(-95.35, 412.01, -39.79)
	event.CmrsSetRef(-253.9, 198.62, -86.06)
	event.SndSePlay(var1, 0)
	event.SetFadeIn(30)
	helper_4be4f575(8200010)
	if vm.skipping() then
		return skip(2)
	end
	helper_d9c15850(2)
	if vm.skipping() then
		return skip(3)
	end
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(-57.24, 82.46, -60.42)
	event.CmrsSetRef(-126.19, 22.03, -77.1)
	event.CmrsMove2(-57.24, 4.84, -60.42, -126.19, 22.03, -77.1, 90, 0, 1.0)
	helper_4be4f575(8200020)
	if vm.skipping() then
		return skip(5)
	end
	helper_4be4f575(8200030)
	if vm.skipping() then
		return skip(6)
	end
	helper_4be4f575(8200040)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(0, "左向く", 6)
	event.ObjsNextMotion(0, "左向く会話", 6)
	event.ObjsNextMotion(0, "左向くL", 4)
	helper_4be4f575(8200045)
	if vm.skipping() then
		return skip(8)
	end
	helper_d9c15850(0)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsSetMotion(1, "右向く", 6)
	event.ObjsNextMotion(1, "右向くL", 4)
	helper_4be4f575(8200050)
	if vm.skipping() then
		return skip(10)
	end
	helper_d9c15850(1)
	if vm.skipping() then
		return skip(11)
	end
	event.SetFadeOut(30)
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(12)
	end
	return part2()
end

--- Helper function.
local function helper_169a4()
	local block: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_6dfa44e2(6)
		end
		if at <= 3 then
			helper_6dfa44e2(90)
		end
		if at <= 4 then
			local _ = helper_7841320d(0)
		end
		if at <= 5 then
			helper_6dfa44e2(30)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeOut(0)
	event.SoundAllStop()
	helper_6dfa44e2(6)
	if vm.skipping() then
		return skip(2)
	end
	event.SetFadeIn(0)
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadMovie(5, "movie/end2.mp4")
	if vm.wait() then
		return skip(3)
	end
	event.PauseEnableFlag(0)
	block = event.LoadImg_4(5, "textures/event/e800/e824/e82401.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetColor(0, 0, 0, 0, 128)
	event.SpriteSetPutsize(0, 512, 448)
	event.SpriteSetPos(0, 256, 224)
	event.SpriteSetDraw(0, 1)
	event.SpriteInit(1)
	event.SpriteSetType(1, 0)
	event.SpriteSetTexture(1, "e82401", block)
	event.SpriteSetColor(1, 128, 128, 128, 128)
	event.SpriteSetUvsize(1, 0, 0, 512, 448)
	event.SpriteSetPutsize(1, 512, 448)
	event.SpriteSetPos(1, 256, 224)
	event.SpriteSetDraw(1, 1)
	event.SetFadeIn(60)
	helper_6dfa44e2(90)
	if vm.skipping() then
		return skip(4)
	end
	while true do
		if helper_7841320d(0) ~= 0 then
			break
		else
			if vm.wait() then
				return skip(5)
			end
		end
	end
	event.SetFadeOut(30)
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(6)
	end
end

--- Helper function.
local function helper_c64c(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7a5e82c7(1, 4)
			helper_73d6f64a(1, vm.i32(60 + arg0), 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_7a5e82c7(1, 4)
	helper_73d6f64a(1, vm.i32(60 + arg0), 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_db58(arg0: s32, arg1: s32)
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
				helper_6dfa44e2(30)
			end
			if at <= 2 then
				helper_3a74ecc4()
			end
			if at <= 3 then
				helper_6dfa44e2(30)
			end
			if at <= 4 then
				helper_73f3f94a(arg1, -1)
			end
			if at <= 5 then
				helper_6dfa44e2(10)
			end
			if at <= 6 then
				helper_6dfa44e2(30)
			end
			if at <= 7 then
				helper_6dfa44e2(120)
			end
			if at <= 8 then
				local _ = helper_7841320d(0)
			end
			if at <= 9 then
				helper_c64c(1)
			end
			if at <= 10 then
				helper_c64c(4)
			end
			if at <= 11 then
				helper_c64c(active_chr_no)
			end
			if at <= 12 then
				helper_c64c(1)
			end
			if at <= 13 then
				helper_6dfa44e2(30)
			end
			if at <= 15 then
				helper_6dfa44e2(30)
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
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(2)
	end
	event.SetStatusbarShow(0, 0.06666667)
	helper_3a74ecc4()
	if vm.skipping() then
		return skip(3)
	end
	event.LoadBgmPack(60)
	if var8 == 1 or var8 ~= 1 and arg1 < 0 then
		event.PlayBgm(0)
	end
	helper_6dfa44e2(30)
	if vm.skipping() then
		return skip(4)
	end
	event.DngPause(1, 1)
	event.DngCollisionAllClr()
	if var8 ~= 1 then
		block = event.LoadImg_4(5, "textures/dungeon/image/gameover.json", 1) or block
		if arg1 >= 0 then
			helper_73f3f94a(arg1, -1)
			if vm.skipping() then
				return skip(5)
			end
			helper_6dfa44e2(10)
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
		helper_6dfa44e2(30)
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
		helper_6dfa44e2(120)
		if vm.skipping() then
			return skip(8)
		end
		while true do
			if helper_7841320d(0) ~= 0 then
				break
			end
			if vm.wait() then
				return skip(9)
			end
		end
	elseif active_chr_no == 3 then
		var10 = event.CheckEnableCharaChange(1) or var10
		if var10 == 0 then
			helper_c64c(1)
			if vm.skipping() then
				return skip(10)
			end
		else
			helper_c64c(4)
			if vm.skipping() then
				return skip(11)
			end
		end
	elseif active_chr_no == 0 or active_chr_no == 2 then
		helper_c64c(active_chr_no)
		if vm.skipping() then
			return skip(12)
		end
	else
		helper_c64c(1)
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
		helper_6dfa44e2(30)
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
		helper_6dfa44e2(30)
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
	helper_6dfa44e2(4)
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
local function helper_febc(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		return helper_db58(arg0, arg1)
	end
	if vm.skipping() then
		return skip(1)
	end
	return helper_db58(arg0, arg1)
end

--- Helper function.
local function helper_fe24(arg0: s32)
	return helper_db58(arg0, -1)
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script[99] = program_99

--- Program 100.
script[100] = function()
	program_99()
	helper_4d0c9edd(vm.f32(972.08), vm.f32(-72.14), vm.f32(1770.23), vm.f32(-2.36))
	event.SetCameraRef(972.08, -42.14, 1770.23)
	event.SetCameraPos(1061.01, -40.06, 1860.38)
	event.ResetCamera(0)
	event.SetFadeIn(30)
	event.Finish()
end

--- Program 150.
-- Defined empty, so the engine runs this instead of its default.
script[150] = function() end

--- Program 151.
script[151] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	program_28020()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 152.
script[152] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f08(32)
		end
	end
	event.SetCameraRef(0.0, 0.0, 0.0)
	if vm.wait() then
		return skip(1)
	end
	helper_f08(32)
	if vm.skipping() then
		return skip(2)
	end
end

--- Program 300.
script[300] = function()
	local active_chr_no: s32 = 0
	local var1: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_73d6f64a(0, 21, 5, 256, 208)
			end
			return
		end
		if at <= 3 then
			helper_6dfa44e2(30)
		end
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 1)
		if active_chr_no == 2 then
			helper_73d6f64a(0, 20, 5, 256, 208)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_73d6f64a(0, 21, 5, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		end
		event.Finish()
		return
	end
	var1 = helper_31a4c001(2, -1)
	if vm.skipping() then
		return skip(3)
	end
	if var1 == 0 then
		event.SetFadeOut(30)
		helper_6dfa44e2(30)
		if vm.skipping() then
			return skip(4)
		end
		event.LoadScript("d07/d07.stb", 1000)
	else
		event.Finish()
	end
end

--- Program 500.
script[500] = function()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_73d6f64a(0, 21, 5, 256, 208)
			end
			return
		end
		if at <= 3 then
			var1 = 2
			helper_6dfa44e2(6)
		end
		if at <= 5 then
			helper_6dfa44e2(20)
		end
		if at <= 6 then
			helper_10694()
			if not vm.skipping() then
				return landing1()
			end
		end
		if at <= 8 then
			helper_4d0c9edd(vm.f32(438.61), 0.0, vm.f32(192.19), vm.f32(-1.89))
			helper_ff48()
		end
		if at <= 9 then
			helper_6dfa44e2(6)
		end
	end
	function part2()
		event.DngPause(1, 0)
		event.Finish()
	end
	function landing1()
		if vm.wait() then
			return skip(8)
		end
		event.Initialize()
		event.EohSyncObj(0, "p05")
		event.EohSetShow(0, 1)
		event.EohSyncObj(1, "p06")
		event.EohSetShow(1, 1)
		event.SetBitCtrl(1, 1)
		event.LoadMonsterFile(629, 1)
		event.LoadMonsterFile(630, 0)
		event.AutoSetMonster(629, -513.2, 9.0, -127.2, 0.0, 1.25, 0.0)
		helper_4d0c9edd(vm.f32(438.61), 0.0, vm.f32(192.19), vm.f32(-1.89))
		event.SetCameraRef(438.61, 30.0, 192.19)
		event.SetCameraPos(590.29, 39.11, 243.1)
		event.ResetCamera(0)
		event.SetFadeIn(30)
		event.Finish()
		event.SetStatusbarShow(1, 0.16666667)
		helper_6dfa44e2(6)
		if vm.skipping() then
			return skip(10)
		end
		return part2()
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 1)
		if active_chr_no == 2 then
			helper_73d6f64a(0, 20, 5, 256, 208)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_73d6f64a(0, 21, 5, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		end
		event.Finish()
		return
	end
	event.ActchrSetDefMotion(0)
	var1 = event.GetEventData_2(6) or var1
	if var1 == 1 then
		event.SetMesWindowMode(0, 1)
		event.SetMesShippo(0, 0)
		event.SetMesDrawspeed(0, 1)
		event.MesMake_2(0, "大きな岩が道をふさいでいる。\n（(#)ボタンでメニューを開く）")
		var2 = helper_8394(0, -1, 5, 256, 208, var2)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMesShippo(0, 1)
		event.SetMesDrawspeed(0, 0)
		if var2 == 1 then
			var1 = 2
		end
	end
	if var1 == 2 then
		event.SetStatusbarShow(0, 0.16666667)
		helper_6dfa44e2(6)
		if vm.skipping() then
			return skip(4)
		end
		event.GotoUseItem(173)
		do
			local skipped = vm.wait()
			var3 = event.DeferredOutput() or var3
			if skipped then
				return skip(5)
			end
		end
		if var3 == 173 then
			event.FadeOutBgm(20)
			event.SetFadeOut(20)
			helper_6dfa44e2(20)
			if vm.skipping() then
				return skip(6)
			end
			event.FuncPointShow("p04", "func", 0)
			helper_10694()
			if vm.skipping() then
				return skip(7)
			end
			if vm.wait() then
				return skip(8)
			end
			event.Initialize()
			event.EohSyncObj(0, "p05")
			event.EohSetShow(0, 1)
			event.EohSyncObj(1, "p06")
			event.EohSetShow(1, 1)
			event.SetBitCtrl(1, 1)
			event.LoadMonsterFile(629, 1)
			event.LoadMonsterFile(630, 0)
			event.AutoSetMonster(629, -513.2, 9.0, -127.2, 0.0, 1.25, 0.0)
			helper_4d0c9edd(vm.f32(438.61), 0.0, vm.f32(192.19), vm.f32(-1.89))
			event.SetCameraRef(438.61, 30.0, 192.19)
			event.SetCameraPos(590.29, 39.11, 243.1)
			event.ResetCamera(0)
			event.SetFadeIn(30)
			event.Finish()
		elseif var3 <= 0 then
		else
			helper_ff48()
			if vm.skipping() then
				return skip(9)
			end
		end
		event.SetStatusbarShow(1, 0.16666667)
		helper_6dfa44e2(6)
		if vm.skipping() then
			return skip(10)
		end
	end
	return part2()
end

--- Program 510.
script[510] = function()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_14efc()
			if not vm.skipping() then
				return part2()
			end
		end
		if at <= 2 then
			helper_169a4()
		end
	end
	function part2()
		helper_169a4()
		if vm.skipping() then
			return skip(3)
		end
		event.SetExitFlag(1)
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	event.FadeOutBgm(20)
	event.SetFadeOut(20)
	helper_6dfa44e2(20)
	if vm.skipping() then
		return skip(1)
	end
	event.DelMonster(-1)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 then
		event.DngSetupMainUnit(0)
	end
	if active_chr_no == 3 then
		event.DngSetupMainUnit(1)
	end
	event.EohSyncObj(0, "p05")
	event.EohSetShow(0, 0)
	event.EohSyncObj(1, "p06")
	event.EohSetShow(1, 0)
	event.SetBitCtrl(1, 0)
	helper_14efc()
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
				helper_febc(0, 8600070)
			end
			return
		end
	end
	flag = event.GetFlag(816) or flag
	flag_2 = event.GetFlag(820) or flag_2
	if flag ~= 0 and flag_2 == 0 then
		value = 0
		value = event.GetRandInt(100) or value
		if value < 50 then
			helper_febc(0, 8600060)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_febc(0, 8600070)
			if vm.skipping() then
				return skip(2)
			end
		end
		return
	end
	helper_fe24(0)
	if vm.skipping() then
		return skip(3)
	end
end

--- Program 18160.
script[18160] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_10694()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 18200.
script[18200] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_169a4()
		end
	end
	helper_14efc()
	if vm.skipping() then
		return skip(1)
	end
	helper_169a4()
	if vm.skipping() then
		return skip(2)
	end
	event.SetExitFlag(1)
end

script[28020] = program_28020

return script
